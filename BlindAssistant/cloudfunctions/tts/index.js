// 讯飞语音合成 WebAPI（流式版）云函数
// 密钥获取：讯飞开放平台 https://console.xfyun.cn → 创建应用 → 语音合成(WebAPI)
const APPID = 'ca488679'
const API_KEY = '9305ca355a700db31e8b45324247d076'
const API_SECRET = 'ZWY5OWlyMWFhNTJkOGI4YWJhMzg3NmRI'

const WebSocket = require('ws')
const crypto = require('crypto')

// RFC1123 格式 GMT 时间
function dateNow() {
	const now = new Date()
	const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
	const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
	return `${days[now.getUTCDay()]}, ${now.getUTCDate()} ${months[now.getUTCMonth()]} ${now.getUTCFullYear()} ${now.getUTCHours()}:${now.getUTCMinutes()}:${now.getUTCSeconds()} GMT`
}

// 生成鉴权 URL
function buildAuthUrl() {
	const host = 'tts-api.xfyun.cn'
	const date = dateNow()
	const signatureOrigin = `host: ${host}\ndate: ${date}\nGET /v2/tts HTTP/1.1`
	const signatureSha = crypto.createHmac('sha256', API_SECRET).update(signatureOrigin).digest('base64')
	const authorizationOrigin = `api_key="${API_KEY}", algorithm="hmac-sha256", headers="host date request-line", signature="${signatureSha}"`
	const authorization = Buffer.from(authorizationOrigin).toString('base64')
	return `wss://${host}/v2/tts?authorization=${encodeURIComponent(authorization)}&date=${encodeURIComponent(date)}&host=${encodeURIComponent(host)}`
}

// 调用讯飞 TTS，返回 mp3 Buffer
function tts(text) {
	return new Promise((resolve, reject) => {
		const url = buildAuthUrl()
		const wsClient = new WebSocket(url)
		const audioChunks = []

		wsClient.on('open', () => {
			wsClient.send(JSON.stringify({
				common: { app_id: APPID },
				business: {
					aue: 'lame',        // mp3 格式
					sfl: 1,             // 开启流式返回
					vcn: 'xiaoyan',     // 发音人：小燕（女声，清晰）
					speed: 50,
					pitch: 50,
					volume: 100,
					bgs: 0,
					tte: 'UTF8'
				},
				data: {
					status: 2,
					text: Buffer.from(text).toString('base64')
				}
			}))
		})

		wsClient.on('message', (data, isBinary) => {
			if (isBinary) {
				audioChunks.push(data)
				return
			}
			const res = JSON.parse(data.toString())
			if (res.code !== 0) {
				reject(new Error(`讯飞TTS错误 ${res.code}: ${res.message}`))
				wsClient.close()
				return
			}
			if (res.data && res.data.audio) {
				audioChunks.push(Buffer.from(res.data.audio, 'base64'))
			}
			if (res.data && res.data.status === 2) {
				// 最后一帧
				wsClient.close()
				resolve(Buffer.concat(audioChunks))
			}
		})

		wsClient.on('error', reject)
		wsClient.on('close', () => {
			if (audioChunks.length === 0) reject(new Error('未收到音频数据'))
		})
	})
}

exports.main = async (event) => {
	const { text } = event
	if (!text) return { ok: false, msg: '缺少 text 参数' }

	const { init, uploadFile } = require('wx-server-sdk')
	init()

	const audioBuffer = await tts(text)
	const cloudPath = `tts/${Date.now()}-${Math.floor(Math.random() * 10000)}.mp3`
	const uploadRes = await uploadFile({ cloudPath, fileContent: audioBuffer })
	return { ok: true, fileID: uploadRes.fileID }
}

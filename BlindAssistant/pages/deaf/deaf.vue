<template>
	<view class="page">
		<!-- 顶部文字展示区 -->
		<view class="text-area">
			<text class="transcript-text">{{ transcriptText }}</text>
		</view>

		<!-- 底部操作区 -->
		<view class="control-area">
			<!-- 录音按钮 -->
			<button
				class="record-btn"
				hover-class="record-btn-hover"
				@click="toggleRecording"
			>
				{{ recording ? '正在聆听...' : '开始录音' }}
			</button>

			<!-- 常用语快捷面板 -->
			<view class="phrases-list">
				<button
					v-for="(phrase, index) in commonPhrases"
					:key="index"
					class="phrase-btn"
					hover-class="phrase-btn-hover"
					@click="speakPhrase(phrase)"
				>
					{{ phrase }}
				</button>
			</view>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			// 录音状态
			recording: false,
			// 顶部文字区内容
			transcriptText: '点击下方按钮开始录音',
			// 录音管理器
			recorderManager: null,
			// 常用语列表
			commonPhrases: ['谢谢', '请帮我一下', '请问洗手间在哪里？', '我需要帮助', '再见']
		}
	},
	onLoad() {
		// 初始化录音管理器
		this.recorderManager = uni.getRecorderManager()
		// 录音停止回调：模拟返回识别结果
		this.recorderManager.onStop(() => {
			this.transcriptText = '请问洗手间在哪里？'
		})
	},
	methods: {
		// 开始 / 停止录音
		toggleRecording() {
			if (!this.recording) {
				// 开始录音
				this.recording = true
				this.transcriptText = '正在识别语音...'
				this.recorderManager.start({ format: 'mp3' })
			} else {
				// 停止录音，触发 onStop 后显示模拟识别结果
				this.recording = false
				this.recorderManager.stop()
			}
		},
		// 常用语：调用微信同声传译插件进行语音播报
		speakPhrase(phrase) {
			this.speakText(phrase)
		},
		// 文字转语音播报（云函数调用讯飞 TTS，合成 mp3 播放）
		speakText(text) {
			const audio = uni.createInnerAudioContext()
			uni.showLoading({ title: '合成语音中...', mask: true })
			wx.cloud.callFunction({
				name: 'tts',
				data: { text: text },
				success: (res) => {
					uni.hideLoading()
					if (res.result && res.result.ok && res.result.fileID) {
						audio.src = res.result.fileID
						audio.play()
					} else {
						uni.showToast({ title: (res.result && res.result.msg) || '播报失败', icon: 'none' })
					}
				},
				fail: (err) => {
					uni.hideLoading()
					console.error('tts 云函数调用失败', err)
					uni.showToast({ title: '语音服务未就绪', icon: 'none' })
				}
			})
		}
	}
}
</script>

<style>
/* 全屏背景图 + Flex 布局（背景图 bg.png 请放到 static 目录） */
.page {
	display: flex;
	flex-direction: column;
	justify-content: space-between;
	min-height: 100vh;
	background-image: url('/static/bg.png');
	background-size: cover;
	background-position: center;
	background-repeat: no-repeat;
	box-sizing: border-box;
}

/* 顶部文字展示区 */
.text-area {
	flex: 1;
	padding: 60rpx 40rpx;
}

/* 识别结果：超大字号加粗 */
.transcript-text {
	display: block;
	font-size: 44px;
	font-weight: bold;
	line-height: 1.5;
	color: #000000;
}

/* 底部操作区 */
.control-area {
	display: flex;
	flex-direction: column;
	align-items: center;
	padding: 40rpx;
}

/* 录音按钮（样式可自行调整） */
.record-btn {
	width: 400rpx;
	height: 400rpx;
	border-radius: 50%;
	background-color: #0B5FFF;
	color: #FFFFFF;
	font-size: 48rpx;
	font-weight: bold;
	line-height: 400rpx;
	padding: 0;
	margin-bottom: 60rpx;
}

.record-btn-hover {
	background-color: #003eb3;
}

/* 常用语按钮列表 */
.phrases-list {
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	width: 100%;
}

.phrase-btn {
	background-color: #FFE600;
	color: #000000;
	font-size: 40rpx;
	font-weight: bold;
	border: 4rpx solid #000000;
	border-radius: 60rpx;
	padding: 20rpx 40rpx;
	margin: 12rpx;
	line-height: 1.3;
}

.phrase-btn-hover {
	background-color: #000000;
	color: #FFE600;
}
</style>

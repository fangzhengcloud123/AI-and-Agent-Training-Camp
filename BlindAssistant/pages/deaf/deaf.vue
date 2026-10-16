<template>
	<view class="page">
		<!-- 上半部分：语音转文字结果 -->
		<view class="text-area">
			<text class="area-label">对方说的话</text>
			<scroll-view class="text-scroll" scroll-y>
				<text class="text-result">{{ transcriptText }}</text>
			</scroll-view>
		</view>

		<!-- 下半部分：录音按钮 + 常用语 -->
		<view class="control-area">
			<button
				class="record-btn"
				hover-class="record-btn-hover"
				:aria-label="recording ? '停止录音' : '开始录音'"
				@click="toggleRecording"
			>
				<text class="record-btn-icon">{{ recording ? '■' : '🎤' }}</text>
				<text class="record-btn-text">{{ recording ? '停止录音' : '开始录音' }}</text>
			</button>

			<text class="phrases-label">常用语（点击直接播报）</text>
			<view class="phrases-list">
				<button
					v-for="(phrase, index) in commonPhrases"
					:key="index"
					class="phrase-btn"
					hover-class="phrase-btn-hover"
					:aria-label="phrase"
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
			// 语音转文字结果
			transcriptText: '点击下方按钮开始录音，对方说的话会显示在这里。',
			// 常用语列表
			commonPhrases: ['请帮帮我', '谢谢', '请问洗手间在哪里？', '我需要帮助', '再见']
		}
	},
	methods: {
		// 开始/停止录音（后续在此接入录音 + 语音识别 API）
		toggleRecording() {
			this.recording = !this.recording
			if (this.recording) {
				this.transcriptText = '正在聆听…'
			} else {
				this.transcriptText = '录音已停止。识别结果将显示在这里。'
			}
		},
		// 播报常用语（后续在此接入语音合成 API）
		speakPhrase(phrase) {
			// TODO: 调用语音合成 API 播放 phrase
			console.log('播报常用语：', phrase)
		}
	}
}
</script>

<style>
/* 高对比度设计：深色文字 + 白底 / 蓝底白字按钮，字号偏大 */
.page {
	display: flex;
	flex-direction: column;
	min-height: 100vh;
	background-color: #FFFFFF;
	padding: 30rpx;
	box-sizing: border-box;
}

/* 上半部分：文字结果显示区 */
.text-area {
	display: flex;
	flex-direction: column;
	background-color: #F5F5F5;
	border: 4rpx solid #000000;
	border-radius: 24rpx;
	padding: 30rpx;
	margin-bottom: 30rpx;
}

.area-label {
	font-size: 40rpx;
	font-weight: bold;
	color: #000000;
	margin-bottom: 20rpx;
}

.text-scroll {
	min-height: 400rpx;
}

.text-result {
	font-size: 60rpx;
	line-height: 1.6;
	color: #000000;
	font-weight: 500;
}

/* 下半部分：控制区 */
.control-area {
	display: flex;
	flex-direction: column;
	align-items: center;
}

.record-btn {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	width: 320rpx;
	height: 320rpx;
	border-radius: 50%;
	background-color: #0B5FFF;
	color: #FFFFFF;
	border: 8rpx solid #000000;
	margin-bottom: 40rpx;
}

.record-btn-hover {
	background-color: #003eb3;
}

.record-btn-icon {
	font-size: 90rpx;
	line-height: 1;
	margin-bottom: 16rpx;
}

.record-btn-text {
	font-size: 44rpx;
	font-weight: bold;
}

.phrases-label {
	font-size: 36rpx;
	font-weight: bold;
	color: #000000;
	margin-bottom: 20rpx;
}

.phrases-list {
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	width: 100%;
}

.phrase-btn {
	background-color: #FFE600;
	color: #000000;
	font-size: 44rpx;
	font-weight: bold;
	border: 4rpx solid #000000;
	border-radius: 60rpx;
	padding: 24rpx 48rpx;
	margin: 12rpx;
	line-height: 1.3;
}

.phrase-btn-hover {
	background-color: #000000;
	color: #FFE600;
}
</style>

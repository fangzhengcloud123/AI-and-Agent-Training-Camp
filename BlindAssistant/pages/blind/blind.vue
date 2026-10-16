<template>
	<view class="page">
		<!-- 顶部状态提示 -->
		<view class="status-area">
			<text class="status-text">{{ statusText }}</text>
		</view>

		<!-- 巨大的拍照按钮 -->
		<view class="camera-area">
			<button
				class="camera-btn"
				hover-class="camera-btn-hover"
				aria-label="点击拍照，识别周围环境"
				@click="takePhoto"
			>
				<text class="camera-btn-icon">📷</text>
				<text class="camera-btn-text">点击拍照</text>
			</button>
		</view>

		<!-- AI 识别结果 -->
		<view class="result-area">
			<text class="result-label">识别结果</text>
			<scroll-view class="result-scroll" scroll-y>
				<text class="result-text">{{ resultText }}</text>
			</scroll-view>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			// 页面状态提示
			statusText: '就绪，请点击按钮拍照',
			// AI 识别结果文字
			resultText: '尚未识别。点击上方按钮拍摄照片后，AI 将为您描述周围环境。'
		}
	},
	methods: {
		// 拍照按钮点击事件（后续在此接入拍照 + 识别 API）
		takePhoto() {
			this.statusText = '拍照功能即将接入…'
		}
	}
}
</script>

<style>
/* 纯黑背景 + 亮黄字：高对比度，符合低视力用户无障碍需求 */
.page {
	display: flex;
	flex-direction: column;
	min-height: 100vh;
	background-color: #000000;
	padding: 40rpx;
	box-sizing: border-box;
}

.status-area {
	padding: 20rpx 0 40rpx;
}

.status-text {
	color: #FFE600;
	font-size: 48rpx;
	font-weight: bold;
}

.camera-area {
	display: flex;
	justify-content: center;
	padding: 60rpx 0;
}

/* 巨大按钮：尺寸大、对比度高，方便触摸 */
.camera-btn {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	width: 480rpx;
	height: 480rpx;
	border-radius: 50%;
	background-color: #FFE600;
	color: #000000;
	border: 12rpx solid #FFFFFF;
}

.camera-btn-hover {
	background-color: #FFFFFF;
}

.camera-btn-icon {
	font-size: 120rpx;
	line-height: 1;
	margin-bottom: 20rpx;
}

.camera-btn-text {
	font-size: 64rpx;
	font-weight: bold;
}

.result-area {
	display: flex;
	flex-direction: column;
	background-color: #111111;
	border: 4rpx solid #FFE600;
	border-radius: 24rpx;
	padding: 30rpx;
	margin-top: 20rpx;
}

.result-label {
	color: #FFE600;
	font-size: 40rpx;
	font-weight: bold;
	margin-bottom: 20rpx;
}

.result-scroll {
	max-height: 500rpx;
}

.result-text {
	color: #FFE600;
	font-size: 56rpx;
	line-height: 1.6;
	font-weight: 500;
}
</style>

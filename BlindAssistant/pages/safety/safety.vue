<template>
	<view class="page">
		<!-- 渐变头部 -->
		<view class="header">
			<text class="back" @click="goBack">‹</text>
			<text class="header-title">安全应急</text>
		</view>

		<!-- 内容区 -->
		<view class="content">
			<!-- 紧急呼叫按钮 -->
			<view class="sos-btn" hover-class="sos-btn-hover" @click="sendSos">
				<text class="sos-text">SOS</text>
				<text class="sos-desc">紧急求助</text>
			</view>

			<!-- 紧急联系人卡片 -->
			<view class="card">
				<text class="card-title">紧急联系人</text>
				<view class="contact-row">
					<view class="contact-info">
						<text class="contact-name">妈妈</text>
						<text class="contact-phone">138****0000</text>
					</view>
					<view class="call-btn" hover-class="call-btn-hover" @click="callContact('妈妈')">
						<text class="call-btn-text">📞 呼叫</text>
					</view>
				</view>
				<view class="contact-row">
					<view class="contact-info">
						<text class="contact-name">紧急救援 110</text>
						<text class="contact-phone">报警服务</text>
					</view>
					<view class="call-btn" hover-class="call-btn-hover" @click="callContact('110')">
						<text class="call-btn-text">📞 呼叫</text>
					</view>
				</view>
			</view>

			<!-- 当前位置卡片 -->
			<view class="card">
				<text class="card-title">当前位置</text>
				<text class="location-text">{{ locationText }}</text>
				<view class="locate-btn" hover-class="locate-btn-hover" @click="getLocation">
					<text class="locate-btn-text">📍 获取我的位置</text>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			// 位置信息
			locationText: '位置未获取'
		}
	},
	methods: {
		// 发送 SOS
		sendSos() {
			uni.showModal({
				title: '紧急求助',
				content: '将立即向紧急联系人发送您的求助信息和位置（演示）',
				success(res) {
					if (res.confirm) {
						uni.showToast({ title: '求助信息已发送（模拟）', icon: 'none' })
					}
				}
			})
		},
		// 呼叫联系人
		callContact(name) {
			uni.showToast({ title: '正在呼叫 ' + name + '（模拟）', icon: 'none' })
		},
		// 获取位置
		getLocation() {
			const that = this
			uni.getLocation({
				type: 'wgs84',
				success(res) {
					that.locationText = '经度 ' + res.longitude.toFixed(5) + '，纬度 ' + res.latitude.toFixed(5)
				},
				fail() {
					uni.showToast({ title: '获取位置失败，请检查授权', icon: 'none' })
				}
			})
		},
		goBack() {
			uni.navigateBack()
		}
	}
}
</script>

<style scoped>
.page {
	min-height: 100vh;
	background-color: #F7F9FA;
}

.header {
	display: flex;
	align-items: center;
	justify-content: center;
	position: relative;
	height: 160rpx;
	padding-top: 60rpx;
	background: linear-gradient(to bottom, #11C2AD, #20D1BA);
	box-sizing: border-box;
}

.header-title {
	color: #FFFFFF;
	font-size: 40rpx;
	font-weight: bold;
}

.back {
	position: absolute;
	left: 30rpx;
	bottom: 30rpx;
	color: #FFFFFF;
	font-size: 60rpx;
	line-height: 1;
}

.content {
	padding: 40rpx 30rpx;
}

/* SOS 大按钮 */
.sos-btn {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	width: 360rpx;
	height: 360rpx;
	border-radius: 50%;
	background-color: #FF3B30;
	margin: 20rpx auto 50rpx;
	box-shadow: 0 8rpx 30rpx rgba(255, 59, 48, 0.4);
}

.sos-btn-hover {
	background-color: #d93228;
}

.sos-text {
	color: #FFFFFF;
	font-size: 90rpx;
	font-weight: bold;
}

.sos-desc {
	color: #FFFFFF;
	font-size: 32rpx;
	margin-top: 10rpx;
}

/* 白色卡片 */
.card {
	background-color: #FFFFFF;
	border-radius: 24rpx;
	padding: 30rpx;
	margin-bottom: 30rpx;
	box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
}

.card-title {
	font-size: 34rpx;
	font-weight: bold;
	color: #000000;
	display: block;
	margin-bottom: 20rpx;
}

/* 联系人行 */
.contact-row {
	display: flex;
	flex-direction: row;
	align-items: center;
	justify-content: space-between;
	padding: 20rpx 0;
	border-bottom: 2rpx solid #F0F0F0;
}

.contact-info {
	display: flex;
	flex-direction: column;
}

.contact-name {
	font-size: 32rpx;
	color: #000000;
}

.contact-phone {
	font-size: 26rpx;
	color: #888888;
	margin-top: 6rpx;
}

.call-btn {
	background-color: #11C2AD;
	border-radius: 50rpx;
	padding: 14rpx 32rpx;
}

.call-btn-hover {
	background-color: #0ea896;
}

.call-btn-text {
	color: #FFFFFF;
	font-size: 28rpx;
	font-weight: bold;
}

/* 位置 */
.location-text {
	font-size: 28rpx;
	color: #666666;
	display: block;
	margin-bottom: 20rpx;
}

.locate-btn {
	background-color: #E0F5F2;
	border-radius: 50rpx;
	padding: 18rpx;
	text-align: center;
}

.locate-btn-hover {
	background-color: #c8ece7;
}

.locate-btn-text {
	color: #11C2AD;
	font-size: 30rpx;
	font-weight: bold;
}
</style>

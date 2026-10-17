<template>
	<view class="page">
		<!-- 顶部标题区 -->
		<view class="header">
			<text class="app-title">有声无声</text>
			<text class="app-subtitle">听障无障碍助手</text>
		</view>

		<!-- 提示卡片 -->
		<view class="notice-card">
			<view class="notice-left">
				<text class="notice-text">您好，我是听障人士，</text>
				<text class="notice-text">请尽量使用文字和我交流</text>
			</view>
			<view class="notice-btn" hover-class="notice-btn-hover" @click="showCard">
				<text class="notice-btn-text">出示卡片</text>
			</view>
		</view>

		<!-- 功能宫格：2 x 2 -->
		<view class="grid">
			<view
				v-for="(item, index) in menuList"
				:key="index"
				class="grid-card"
				hover-class="grid-card-hover"
				@click="onMenuClick(item)"
			>
				<text class="grid-title">{{ item.title }}</text>
				<view class="grid-icons">
					<image
						v-for="(icon, i) in item.icons"
						:key="i"
						class="grid-icon-img"
						:src="icon"
						mode="aspectFit"
					/>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			// 功能菜单（静态数据）
			menuList: [
				{ title: '双向沟通', icons: ['/static/icons/mic.jpg', '/static/icons/chat.png'], path: '/pages/deaf/deaf' },
				{ title: '手语查询', icons: ['/static/icons/hand.jpg'], path: '/pages/sign/sign' },
				{ title: '生活便民', icons: ['/static/icons/bucket.png'], path: '/pages/kit/kit' },
				{ title: '安全应急', icons: ['/static/icons/shield.png'], path: '/pages/safety/safety' }
			]
		}
	},
	methods: {
		// 菜单点击：跳转对应页面
		onMenuClick(item) {
			if (item.path) {
				uni.navigateTo({ url: item.path })
			} else {
				uni.showToast({ title: item.title + '开发中', icon: 'none' })
			}
		},
		// 出示卡片
		showCard() {
			uni.showToast({ title: '出示卡片功能开发中', icon: 'none' })
		}
	}
}
</script>

<style scoped>
/* 整页青绿色渐变背景 */
.page {
	min-height: 100vh;
	background: linear-gradient(to bottom, #11C2AD, #20D1BA);
	padding: 100rpx 30rpx 40rpx;
	box-sizing: border-box;
}

/* 顶部标题 */
.header {
	display: flex;
	flex-direction: column;
	margin-bottom: 30rpx;
	padding: 0 10rpx;
}

.app-title {
	color: #FFFFFF;
	font-size: 60rpx;
	font-weight: bold;
}

.app-subtitle {
	color: #FFFFFF;
	font-size: 34rpx;
	margin-top: 10rpx;
}

/* 提示卡片 */
.notice-card {
	display: flex;
	flex-direction: row;
	align-items: center;
	justify-content: space-between;
	background-color: #FFFFFF;
	border-radius: 24rpx;
	padding: 40rpx 30rpx;
	margin-bottom: 30rpx;
	box-shadow: 0 6rpx 20rpx rgba(0, 0, 0, 0.1);
}

.notice-left {
	display: flex;
	flex-direction: column;
}

.notice-text {
	font-size: 34rpx;
	font-weight: bold;
	color: #000000;
	line-height: 1.5;
}

/* 橙色胶囊按钮 */
.notice-btn {
	background-color: #FF9500;
	border-radius: 60rpx;
	padding: 16rpx 32rpx;
}

.notice-btn-hover {
	background-color: #e08600;
}

.notice-btn-text {
	color: #FFFFFF;
	font-size: 30rpx;
	font-weight: bold;
}

/* 2 x 2 宫格 */
.grid {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
	justify-content: space-between;
}

.grid-card {
	display: flex;
	flex-direction: column;
	width: 48%;
	background-color: #FFFFFF;
	border-radius: 24rpx;
	padding: 36rpx 30rpx;
	margin-bottom: 30rpx;
	box-sizing: border-box;
	box-shadow: 0 6rpx 20rpx rgba(0, 0, 0, 0.1);
}

.grid-card-hover {
	background-color: #F0F0F0;
}

.grid-title {
	font-size: 38rpx;
	font-weight: bold;
	color: #000000;
	margin-bottom: 40rpx;
}

.grid-icons {
	display: flex;
	flex-direction: row;
	align-items: center;
}

.grid-icon-img {
	width: 84rpx;
	height: 84rpx;
	margin-right: 30rpx;
}
</style>

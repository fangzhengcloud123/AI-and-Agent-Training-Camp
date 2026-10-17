<template>
	<view class="page">
		<!-- 渐变头部：头像 + 用户名 -->
		<view class="header">
			<view class="avatar">👤</view>
			<view class="user-info">
				<text class="user-name">听障助手用户</text>
				<text class="user-subtitle">无障碍服务已开启</text>
			</view>
		</view>

		<!-- 个人中心统计卡片（压在渐变区下方） -->
		<view class="stats-card">
			<text class="stats-title">个人中心</text>
			<view class="stats-row">
				<view class="stats-item">
					<text class="stats-num">0</text>
					<text class="stats-label">沟通记录</text>
				</view>
				<view class="stats-item">
					<text class="stats-num">0</text>
					<text class="stats-label">手语收藏</text>
				</view>
				<view class="stats-item">
					<text class="stats-num">0</text>
					<text class="stats-label stats-label-bold">求助记录</text>
				</view>
				<view class="stats-item">
					<text class="stats-num">0</text>
					<text class="stats-label">应急联系人</text>
				</view>
			</view>
		</view>

		<!-- 菜单列表 -->
		<view class="menu-card">
			<view
				v-for="(item, index) in menuList"
				:key="index"
				class="menu-row"
				hover-class="menu-row-hover"
				@click="onMenuClick(item)"
			>
				<image class="menu-icon-img" :src="item.icon" mode="aspectFit" />
				<text class="menu-title">{{ item.title }}</text>
				<text class="menu-arrow">›</text>
			</view>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			// 菜单（静态数据）
			menuList: [
				{ icon: '/static/icons/briefcase.png', title: '个人资料' },
				{ icon: '/static/icons/shield.png', title: '紧急联系人' },
				{ icon: '/static/icons/chat.png', title: '语音设置' },
				{ icon: '/static/icons/envelope.png', title: '帮助反馈' },
				{ icon: '/static/icons/question.png', title: '关于我们' },
				{ icon: '/static/icons/question.png', title: '使用帮助' }
			]
		}
	},
	methods: {
		onMenuClick(item) {
			uni.showToast({ title: item.title + '（开发中）', icon: 'none' })
		}
	}
}
</script>

<style scoped>
.page {
	min-height: 100vh;
	background-color: #F7F9FA;
}

/* 渐变头部 */
.header {
	display: flex;
	flex-direction: row;
	align-items: center;
	height: 320rpx;
	padding: 80rpx 40rpx 0;
	background: linear-gradient(to bottom, #11C2AD, #20D1BA);
	box-sizing: border-box;
}

.avatar {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 120rpx;
	height: 120rpx;
	border-radius: 50%;
	border: 4rpx solid #FFFFFF;
	background-color: rgba(255, 255, 255, 0.2);
	font-size: 64rpx;
	margin-right: 28rpx;
}

.user-info {
	display: flex;
	flex-direction: column;
}

.user-name {
	color: #FFFFFF;
	font-size: 44rpx;
	font-weight: bold;
}

.user-subtitle {
	color: rgba(255, 255, 255, 0.9);
	font-size: 28rpx;
	margin-top: 10rpx;
}

/* 统计卡片：负边距压住渐变区 */
.stats-card {
	position: relative;
	z-index: 1;
	background-color: #FFFFFF;
	border-radius: 24rpx;
	padding: 30rpx;
	margin: -60rpx 30rpx 30rpx;
	box-shadow: 0 6rpx 20rpx rgba(0, 0, 0, 0.08);
}

.stats-title {
	font-size: 34rpx;
	font-weight: bold;
	color: #000000;
	display: block;
	margin-bottom: 24rpx;
}

.stats-row {
	display: flex;
	flex-direction: row;
}

.stats-item {
	flex: 1;
	display: flex;
	flex-direction: column;
	align-items: center;
}

.stats-num {
	font-size: 48rpx;
	font-weight: bold;
	color: #000000;
}

.stats-label {
	font-size: 26rpx;
	color: #666666;
	margin-top: 8rpx;
}

.stats-label-bold {
	font-weight: bold;
}

/* 菜单卡片 */
.menu-card {
	background-color: #FFFFFF;
	border-radius: 24rpx;
	padding: 0 30rpx;
	margin: 0 30rpx;
	box-shadow: 0 6rpx 20rpx rgba(0, 0, 0, 0.08);
}

.menu-row {
	display: flex;
	flex-direction: row;
	align-items: center;
	padding: 32rpx 0;
	border-bottom: 2rpx solid #F0F0F0;
}

.menu-row:last-child {
	border-bottom: none;
}

.menu-row-hover {
	background-color: #F7F9FA;
}

.menu-icon-img {
	width: 44rpx;
	height: 44rpx;
	margin-right: 24rpx;
}

.menu-title {
	flex: 1;
	font-size: 34rpx;
	color: #000000;
}

.menu-arrow {
	font-size: 44rpx;
	color: #BBBBBB;
}
</style>

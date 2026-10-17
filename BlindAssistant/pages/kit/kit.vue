<template>
	<view class="page">
		<!-- 顶部渐变导航区 -->
		<view class="navbar">
			<text class="navbar-title">消息</text>
			<view class="navbar-icons">
				<text class="navbar-icon" @click="onNav('搜索')">🔍</text>
				<text class="navbar-icon" @click="onNav('编辑')">✏️</text>
			</view>
		</view>

		<!-- 搜索框 -->
		<view class="search-wrap">
			<view class="search-box">
				<text class="search-icon">🔍</text>
				<text class="search-placeholder">搜索消息、联系人、手语翻译</text>
			</view>
		</view>

		<!-- 消息卡片列表 -->
		<view class="msg-list">
			<image
				v-for="(item, index) in msgList"
				:key="index"
				class="msg-card"
				:src="item.img"
				mode="widthFix"
				hover-class="msg-card-hover"
				@click="onMsgClick(item)"
			/>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			// 消息卡片（设计图）
			msgList: [
				{ img: '/static/cards/msg-interact.jpg', title: '互动消息' },
				{ img: '/static/cards/msg-assistant.jpg', title: '双向沟通助手', path: '/pages/deaf/deaf' },
				{ img: '/static/cards/msg-sign.jpg', title: '手语查询' },
				{ img: '/static/cards/msg-safety.jpg', title: '安全应急通知' }
			]
		}
	},
	methods: {
		onMsgClick(item) {
			if (item.path) {
				uni.navigateTo({ url: item.path })
			} else {
				uni.showToast({ title: item.title + '（开发中）', icon: 'none' })
			}
		},
		onNav(name) {
			uni.showToast({ title: name + '功能开发中', icon: 'none' })
		}
	}
}
</script>

<style scoped>
.page {
	min-height: 100vh;
	background: linear-gradient(to bottom, #11C2AD, #20D1BA);
}

/* 渐变导航区 */
.navbar {
	display: flex;
	align-items: center;
	justify-content: center;
	position: relative;
	height: 180rpx;
	padding-top: 80rpx;
	box-sizing: border-box;
}

.navbar-title {
	color: #FFFFFF;
	font-size: 44rpx;
	font-weight: bold;
}

.navbar-icons {
	position: absolute;
	right: 30rpx;
	bottom: 36rpx;
	display: flex;
	flex-direction: row;
}

.navbar-icon {
	color: #FFFFFF;
	font-size: 40rpx;
	margin-left: 32rpx;
}

/* 搜索框 */
.search-wrap {
	padding: 0 30rpx;
	margin-top: 10rpx;
}

.search-box {
	display: flex;
	flex-direction: row;
	align-items: center;
	background-color: #FFFFFF;
	border-radius: 60rpx;
	padding: 22rpx 32rpx;
	box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
}

.search-icon {
	font-size: 32rpx;
	margin-right: 16rpx;
}

.search-placeholder {
	color: #999999;
	font-size: 30rpx;
}

/* 消息列表 */
.msg-list {
	display: flex;
	flex-direction: column;
	padding: 30rpx 24rpx;
}

.msg-card {
	width: 100%;
	border-radius: 24rpx;
	margin-bottom: 24rpx;
	box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.08);
}

.msg-card-hover {
	opacity: 0.85;
}
</style>

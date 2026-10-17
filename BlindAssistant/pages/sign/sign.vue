<template>
	<view class="page">
		<!-- 渐变头部 -->
		<view class="header">
			<text class="back" @click="goBack">‹</text>
			<text class="header-title">手语查询</text>
		</view>

		<!-- 内容区 -->
		<view class="content">
			<!-- 搜索框 -->
			<view class="search-box">
				<text class="search-icon">🔍</text>
				<input class="search-input" placeholder="搜索常用语，如：谢谢" v-model="keyword" />
			</view>

			<!-- 常用手语列表 -->
			<view class="sign-list">
				<view
					v-for="(item, index) in filteredList"
					:key="index"
					class="sign-card"
					hover-class="sign-card-hover"
					@click="showDetail(item)"
				>
					<view class="sign-icon">{{ item.icon }}</view>
					<view class="sign-body">
						<text class="sign-word">{{ item.word }}</text>
						<text class="sign-desc">{{ item.desc }}</text>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			// 搜索关键词
			keyword: '',
			// 常用手语数据（静态）
			signList: [
				{ icon: '👋', word: '你好', desc: '右手抬起挥动，掌心朝外' },
				{ icon: '🙏', word: '谢谢', desc: '双手拇指弯曲，其余四指并拢轻点胸口' },
				{ icon: '🙇', word: '对不起', desc: '右手握拳轻触额头，身体微前倾' },
				{ icon: '👍', word: '很棒', desc: '竖起大拇指，向前点两下' },
				{ icon: '🖐️', word: '再见', desc: '手掌朝外左右挥动' },
				{ icon: '🆘', word: '救命', desc: '一手拍肩一手高举挥动' },
				{ icon: '🚻', word: '洗手间', desc: '拇指翘起在耳边，其余四指弯曲扇动' },
				{ icon: '🍚', word: '吃饭', desc: '一手拇食指捏合，做扒饭动作' }
			]
		}
	},
	computed: {
		// 按关键词过滤
		filteredList() {
			const k = this.keyword.trim()
			if (!k) return this.signList
			return this.signList.filter(item => item.word.includes(k) || item.desc.includes(k))
		}
	},
	methods: {
		showDetail(item) {
			uni.showToast({ title: '查看「' + item.word + '」手势图', icon: 'none' })
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

/* 渐变头部 */
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

/* 内容区 */
.content {
	padding: 30rpx;
}

/* 搜索框 */
.search-box {
	display: flex;
	flex-direction: row;
	align-items: center;
	background-color: #FFFFFF;
	border-radius: 60rpx;
	padding: 20rpx 30rpx;
	margin-bottom: 30rpx;
	box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
}

.search-icon {
	font-size: 32rpx;
	margin-right: 16rpx;
}

.search-input {
	flex: 1;
	font-size: 30rpx;
}

/* 列表 */
.sign-list {
	display: flex;
	flex-direction: column;
}

.sign-card {
	display: flex;
	flex-direction: row;
	align-items: center;
	background-color: #FFFFFF;
	border-radius: 24rpx;
	padding: 30rpx;
	margin-bottom: 24rpx;
	box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.05);
}

.sign-card-hover {
	background-color: #F0F0F0;
}

.sign-icon {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100rpx;
	height: 100rpx;
	border-radius: 50%;
	background-color: #E0F5F2;
	font-size: 52rpx;
	margin-right: 28rpx;
}

.sign-body {
	display: flex;
	flex-direction: column;
}

.sign-word {
	font-size: 36rpx;
	font-weight: bold;
	color: #000000;
	margin-bottom: 8rpx;
}

.sign-desc {
	font-size: 26rpx;
	color: #888888;
}
</style>

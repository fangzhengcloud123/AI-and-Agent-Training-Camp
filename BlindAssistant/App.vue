<script>
	export default {
		onLaunch: function() {
			console.log('App Launch')
			// 初始化云开发（使用默认环境）
			try {
				wx.cloud.init({ traceUser: true })
			} catch (e) {
				console.error('云开发初始化失败', e)
			}
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		}
	}
</script>

<style>
	/*每个页面公共css */
</style>

'use strict';

// Minimal WeChat cloud function template for BlindAssistant.
// In WeChat DevTools: right-click this folder -> "Upload & Deploy: All files".
exports.main = async (event, context) => {
  return {
    code: 0,
    message: 'hello from BlindAssistant cloud',
    openid: context.OPENID || null,
    event: event || {}
  };
};

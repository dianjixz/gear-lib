#ifndef _rtmp_client_h_
#define _rtmp_client_h_

#include <stdlib.h>

#if defined(__cplusplus)
extern "C" {
#endif

	void* rtmp_client_create(const char* url);
	void rtmp_client_destroy(void* p);

	///@param[in] audio: AAC AudioSpecificConfig
	///@param[in] abytes: AudioSpecificConfig length in bytes
	///@param[in] video: H264 AVCDecoderConfigurationRecord
	///@param[in] vbytes: AVCDecoderConfigurationRecord length in bytes
	///@return 0-ok, other-error
	int rtmp_client_set_header(void* rtmp, const void* audio, unsigned int abytes, const void* video, unsigned int vbytes);

	///@param[in] video: H264 packet(include startcode(00 00 00 01))
	///@param[in] bytes: video length in bytes
	///@return 0-ok, other-error
	int rtmp_client_send_video(void* rtmp, const void* video, unsigned int bytes, unsigned int pts, unsigned int dts);

	// @param[in] audio: AAC audio packet(include AAC packet header(ADTS))
	// @param[in] bytes: video length in bytes
	///@return 0-ok, other-error
	int rtmp_client_send_audio(void* rtmp, const void* audio, unsigned int bytes, unsigned int pts, unsigned int dts);

	void rtmp_client_getserver(void* rtmp, char ip[65]);

	// create AudioSpecificConfig from AAC data
	size_t rtmp_client_make_AudioSpecificConfig(void* out, const void* audio, size_t bytes);

	// creaate AVCDecoderConfigurationRecord from H.264 sps/pps nalu(all nalu must start with 00 00 00 01)
	//size_t rtmp_client_make_AVCDecoderConfigurationRecord(void* out, const void* video, size_t bytes);
	size_t rtmp_client_make_AVCDecoderConfigurationRecord(const void* video, size_t bytes, void* out, size_t osize);

#if defined(__cplusplus)
}
#endif
#endif /* !_rtmp_client_h_ */

import os
import vapoursynth as vs
core = vs.core
core.std.LoadPlugin(os.getenv('LIBRIFE'))

clip = video_in

clip = vs.core.resize.Bicubic(clip, format=vs.RGBS, matrix_in_s='709')

#rife.RIFE(vnode clip[, int model=5, int factor_num=2, int factor_den=1, int fps_num=None, int fps_den=None, string model_path=None, int gpu_id=None, int gpu_thread=2, bint tta=False, bint uhd=False, bint sc=False, bint skip=False, float skip_threshold=60.0, bint list_gpu=False])
clip = core.rife.RIFE(clip, model=9, gpu_id=0, list_gpu=False, gpu_thread=4, tta=True, uhd=False, sc=False)

clip = vs.core.resize.Bicubic(clip, format=vs.YUV420P8, matrix_s="709")

clip.set_output()

# android_hardware_dolby_sea

Dolby DAX 3.12 para o **Redmi Note 12S (sea, MT6781)** — Evolution X / AOSP Android 15-17 com Audio HAL AIDL.
Blobs: Motorola G57 Power (Android 16), os mesmos que foram validados no módulo KernelSU (app abre em Enforcing,
efeito DAP registrado e processando áudio). Esta tree **ainda não foi compilada** (sem fonte AOSP no ambiente onde foi criada).

## Como adicionar
1. Clonar em `hardware/dolby`:
   `git clone <seu-repo> hardware/dolby`
   (ou no `local_manifests`: `<project path="hardware/dolby" name="SEU_USUARIO/android_hardware_dolby_sea" remote="github" revision="main" />`)
2. No device tree (`device.mk`):
   `$(call inherit-product, hardware/dolby/dolby.mk)`
3. Registrar o efeito no `audio_effects_config.xml` do vendor do sea (arquivo que está no device/vendor tree):
   `hardware/dolby/scripts/patch-audio-effects.sh caminho/para/audio_effects_config.xml`
   Adiciona:
   ```xml
   <library name="lunaris_dap" path="libswdapaidl.so"/>
   <effect name="extensioneffect" library="lunaris_dap" uuid="9d4921da-8225-4f29-aefa-39537a04bcaa" type="fa81dbde-588b-11ed-9b6a-0242ac120002"/>
   ```
   (o `type` é o UUID do efeito "Extension" do HAL AIDL; sem ele o app dá `Error: -3`).
4. Compilar e instalar. Sem shim/LD_PRELOAD: o HAL do DMS é declarado no VINTF (`dms-service.xml` + matrix).

## O que tem
- `Android.bp`: prebuilts (libswdapaidl, libdlbdsservice, libdlbpreg, libdmshal, libdapparamstorage, libdeccfg, liboem_specific, vendor.dolby.dms-V1-ndk, vendor.dolby.hardware.dms@2.0, vendor.dolby.dms.service, vintf fragment) + symlink `libstagefright_foundation-v33.so -> libstagefright_foundation.so`.
- `sepolicy/vendor`: domínio `hal_aidl_dms_default`, serviço `vendor.dolby.dms.IDms/default`, cliente audio HAL + app.
- `vintf/dolby_framework_matrix.xml`, `rootdir/etc/init.dolby.rc`, `proprietary/vendor/etc/init/dms-service.rc`.
- `LunarisDolby/`: app (fonte, Compose). `prebuilt-app/`: (opcional, o APK não vai no repo por tamanho — copie `system/product/priv-app/LunarisDolby/LunarisDolby.apk` de dentro do zip do módulo para `prebuilt-app/LunarisDolby.apk`) APK validado, re-assinado com a platform key (fallback: renomeie `prebuilt-app/Android.bp.disabled` para `Android.bp`, copie o APK e troque `LunarisDolby` por `LunarisDolbyPrebuilt` no `dolby.mk`).
- `overlay/DolbyFrameworksResCommon`.

## Se der problema
- **Erro de build `libstagefright_foundation-v33`**: o `install_symlink` só funciona em Soong recente; alternativa é usar o módulo do VNDK snapshot v33 (se existir) em `shared_libs`.
- **Source app não compila** (deps androidx/Compose): use `LunarisDolbyPrebuilt`.
- **AVC denials** no primeiro boot: `dmesg | grep avc`; para depurar, copie `sepolicy/debug/permissive.te.example` para `sepolicy/vendor/permissive.te`.
- **Efeito não aparece**: `adb shell dumpsys media.audio_flinger | grep -i 9d4921da` e `adb logcat | grep -i -E "dms|dolby|AudioEffect"`.
- **Dolby aparece mas sem som audível**: ver tuning do dispositivo (`dax-default.xml` é genérico, do Moto) e se o player usa offload/direct.

Blobs proprietários © Dolby / Motorola — uso por sua conta.

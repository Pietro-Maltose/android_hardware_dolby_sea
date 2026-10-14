#!/bin/sh
# Registers the Dolby DAP effect in an AIDL audio_effects_config.xml (in place).
# Usage: scripts/patch-audio-effects.sh <path/to/audio_effects_config.xml>
# Same edit the KernelSU module applied on the device. Idempotent.
set -e
F="$1"
[ -f "$F" ] || { echo "usage: $0 audio_effects_config.xml" >&2; exit 1; }
if grep -q 'libswdapaidl.so' "$F"; then echo "already patched: $F"; exit 0; fi
grep -q '</libraries>' "$F" && grep -q '</effects>' "$F" || { echo "unexpected format (no </libraries> or </effects>)" >&2; exit 1; }
UUID="9d4921da-8225-4f29-aefa-39537a04bcaa"
EXT="fa81dbde-588b-11ed-9b6a-0242ac120002"
NAME="extensioneffect"
grep -q "name=\"extensioneffect\"" "$F" && NAME="dolby_dap"
sed -i \
 -e "s#</libraries>#    <library name=\"lunaris_dap\" path=\"libswdapaidl.so\"/>\n    </libraries>#" \
 -e "s#</effects>#    <effect name=\"$NAME\" library=\"lunaris_dap\" uuid=\"$UUID\" type=\"$EXT\"/>\n    </effects>#" "$F"
echo "patched $F (effect name: $NAME)"

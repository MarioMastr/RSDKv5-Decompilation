#include "../DrawingLegacy.hpp"

#ifndef DRAWING_LEGACY_V3_H
#define DRAWING_LEGACY_V3_H

namespace Legacy
{

namespace v3
{
void DrawObjectList(int32 group);
void DrawStageGFX();

#if !RETRO_USE_ORIGINAL_CODE
void DrawDebugOverlays();
#endif

bool32 VideoSkipCB();
} // namespace v3

} // namespace Legacy

#endif // DRAWING_LEGACY_V3_H

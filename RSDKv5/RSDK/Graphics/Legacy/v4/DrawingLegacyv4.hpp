#include "../DrawingLegacy.hpp"

#ifndef DRAWING_LEGACY_V4_H
#define DRAWING_LEGACY_V4_H

namespace Legacy
{

namespace v4
{
void DrawObjectList(int32 group);
void DrawStageGFX();

#if !RETRO_USE_ORIGINAL_CODE
void DrawDebugOverlays();
#endif
} // namespace v4

} // namespace Legacy

#endif // DRAWING_LEGACY_V4_H
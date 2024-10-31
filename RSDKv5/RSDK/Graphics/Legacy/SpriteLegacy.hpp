#include "../Sprite.hpp"

#ifndef SPRITE_LEGACY_H
#define SPRITE_LEGACY_H

namespace Legacy
{

int32 AddGraphicsFile(const char *filePath);
void RemoveGraphicsFile(const char *filePath, int32 sheetID);

} // namespace Legacy

#endif // SPRITE_LEGACY_H
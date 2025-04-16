#pragma once

#include "RSDK/Core/RetroEngine.hpp"

namespace Legacy
{

int32 AddGraphicsFile(const char *filePath);
void RemoveGraphicsFile(const char *filePath, int32 sheetID);

} // namespace Legacy
#include "../SceneLegacy.hpp"

#ifndef SCENE_LEGACY_V3_H
#define SCENE_LEGACY_V3_H

namespace Legacy
{

namespace v3
{

extern int32 yScrollA;
extern int32 yScrollB;
extern int32 xScrollA;
extern int32 xScrollB;
extern int32 yScrollMove;

void InitFirstStage();
void ProcessStage();
void HandleCameras();

void ProcessParallaxAutoScroll();

void LoadStageFiles();
void LoadActLayout();
void LoadStageBackground();

void SetPlayerScreenPosition(RSDK::Legacy::v3::Player *player);
void SetPlayerScreenPositionCDStyle(RSDK::Legacy::v3::Player *player);
void SetPlayerHLockedScreenPosition(RSDK::Legacy::v3::Player *player);
void SetPlayerLockedScreenPosition(RSDK::Legacy::v3::Player *player);

} // namespace v3

} // namespace Legacy

#endif // SCENE_LEGACY_V3_H
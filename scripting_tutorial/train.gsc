//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||| Name		: train.gsc
//|||| Info		: Train Example for Scripting Tutorial
//|||| Site		: aviacreations.com
//|||| Author		: Mrpeanut188
//|||| Notes		: 
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

init()
{
  trig = getEntArray( "train_trigger", "targetname" );
  for ( i = 0; i < trig.size; i++ )
  {
    thread train_trigger();
  }
  
  level waittill("train_bought");
  // 
}

train_trigger()
{
  cost = 2000;
  
  for (;;)
  {
    self waittill("trigger", player);
    if (player.score >= cost)
    {
      player.score = player.score - cost;
      level notify("train_bought");
      return;
    }
}

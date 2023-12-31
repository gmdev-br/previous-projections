//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "© GM, 2020, 2021, 2022, 2023"
#property description "Previous Projections"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots 0
#property indicator_type1 DRAW_LINE
#property indicator_color1 Red
#property indicator_label1 "Daily Range Up"

#property indicator_type2 DRAW_LINE
#property indicator_color2 Blue
#property indicator_label2 "Daily Range Down"

double up[], dn[], range[];

input int input_start = 0;
input int input_end = 0;
input color color_up = clrOrange;
input color color_dn = clrRoyalBlue;
input int WaitMilliseconds = 300000;  // Timer (milliseconds) for recalculation

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit() {
   SetIndexBuffer(0, up, INDICATOR_CALCULATIONS);
   SetIndexBuffer(1, dn, INDICATOR_CALCULATIONS);
   SetIndexBuffer(2, range, INDICATOR_CALCULATIONS);
   PlotIndexSetInteger(0, PLOT_LINE_WIDTH, 2);
   PlotIndexSetInteger(1, PLOT_LINE_WIDTH, 2);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, 0.0);

   _updateTimer = new MillisecondTimer(WaitMilliseconds, false);
   EventSetMillisecondTimer(WaitMilliseconds);

   ChartRedraw();


//PlotIndexSetInteger(0,)

   return(0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   delete(_updateTimer);
   ObjectsDeleteAll(0, "projections_");
   ObjectsDeleteAll(0, "proj_");
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const int begin, const double &price[]) {
   return (1);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Update() {

   int totalRates = SeriesInfoInteger(NULL, PERIOD_CURRENT, SERIES_BARS_COUNT);
   if ( totalRates < 10 ) {
      Print("Not enough data to calculate");
      return(0);
   }

   int limit, copied;
   datetime start = D'2023.1.1';

   ArrayInitialize(up, 0);
   ArrayInitialize(dn, 0);

   datetime dayTime[];
   double dayHigh[], dayLow[];
   copied = CopyTime(_Symbol, PERIOD_D1, start, iTime(NULL, PERIOD_D1, input_start + 1), dayTime);
   if(copied <= 0) return 0;
   copied = CopyHigh(_Symbol, PERIOD_D1, start, iTime(NULL, PERIOD_D1, input_start + 1), dayHigh);
   if(copied <= 0) return 0;
   copied = CopyLow(_Symbol, PERIOD_D1, start, iTime(NULL, PERIOD_D1, input_start + 1), dayLow);
   if(copied <= 0) return 0;

   MqlDateTime mdtDay, mdt;
   for(int i = totalRates - 20; i < totalRates; i++) {
      TimeToStruct(iTime(NULL, PERIOD_CURRENT, i), mdt);
      for(int j = copied - input_start - 1; j < copied - input_start - 2; j++) {
         TimeToStruct(dayTime[j], mdtDay);
         if(mdtDay.day == mdt.day) {
            up[i] = dayHigh[j];
            dn[i] = dayLow[j];
            range[i] = up[i] - dn[i];
            int a = 0;
         }
      }
   }

   double t_range = dayHigh[copied - input_start - 1] - dayLow[copied - input_start - 1];

   ObjectCreate(0, "projections_0", OBJ_TREND, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1], iTime(NULL, PERIOD_D1, 0) + PeriodSeconds(PERIOD_D1) *  (1 + input_end), dayHigh[copied - input_start - 1]);
   ObjectSetInteger(0, "projections_0", OBJPROP_COLOR, Yellow);
   ObjectCreate(0, "proj_label_0", OBJ_TEXT, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1]);
   ObjectSetInteger(0, "proj_label_0", OBJPROP_COLOR, Yellow);
   ObjectSetString(0, "proj_label_0", OBJPROP_TEXT, "0%");

   ObjectCreate(0, "projections_25", OBJ_TREND, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1] - t_range * 0.25, iTime(NULL, PERIOD_D1, 0) + PeriodSeconds(PERIOD_D1) *  (1 + input_end), dayHigh[copied - input_start - 1] - t_range * 0.25);
   ObjectSetInteger(0, "projections_25", OBJPROP_COLOR, Yellow);
   ObjectCreate(0, "proj_label_25", OBJ_TEXT, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1] - t_range * 0.25);
   ObjectSetInteger(0, "proj_label_25", OBJPROP_COLOR, Yellow);
   ObjectSetString(0, "proj_label_25", OBJPROP_TEXT, "25%");

   ObjectCreate(0, "projections_50", OBJ_TREND, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1] - t_range * 0.5, iTime(NULL, PERIOD_D1, 0) + PeriodSeconds(PERIOD_D1) *  (1 + input_end), dayHigh[copied - input_start - 1] - t_range * 0.5);
   ObjectSetInteger(0, "projections_50", OBJPROP_COLOR, Yellow);
   ObjectCreate(0, "proj_label_50", OBJ_TEXT, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1] - t_range * 0.5);
   ObjectSetInteger(0, "proj_label_50", OBJPROP_COLOR, Yellow);
   ObjectSetString(0, "proj_label_50", OBJPROP_TEXT, "50%");

   ObjectCreate(0, "projections_75", OBJ_TREND, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1] - t_range * 0.75, iTime(NULL, PERIOD_D1, 0) + PeriodSeconds(PERIOD_D1) *  (1 + input_end), dayHigh[copied - input_start - 1] - t_range * 0.75);
   ObjectSetInteger(0, "projections_75", OBJPROP_COLOR, Yellow);
   ObjectCreate(0, "proj_label_75", OBJ_TEXT, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1] - t_range * 0.75);
   ObjectSetInteger(0, "proj_label_75", OBJPROP_COLOR, Yellow);
   ObjectSetString(0, "proj_label_75", OBJPROP_TEXT, "75%");

   ObjectCreate(0, "projections_100", OBJ_TREND, 0, iTime(NULL, PERIOD_D1, input_start), dayLow[copied - input_start - 1], iTime(NULL, PERIOD_D1, 0) + PeriodSeconds(PERIOD_D1) *  (1 + input_end), dayLow[copied - input_start - 1]);
   ObjectSetInteger(0, "projections_100", OBJPROP_COLOR, Yellow);
   ObjectCreate(0, "proj_label_100", OBJ_TEXT, 0, iTime(NULL, PERIOD_D1, input_start), dayLow[copied - input_start - 1] );
   ObjectSetInteger(0, "proj_label_100", OBJPROP_COLOR, Yellow);
   ObjectSetString(0, "proj_label_100", OBJPROP_TEXT, "100%");

   for(int i = 1; i <= 8; i++) {
      ObjectCreate(0, "projections_up_" + i, OBJ_TREND, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1] + t_range * i * 0.25, iTime(NULL, PERIOD_D1, 0) + PeriodSeconds(PERIOD_D1) *  (1 + input_end), dayHigh[copied - input_start - 1] + t_range * i * 0.25);
      ObjectSetInteger(0, "projections_up_" + i, OBJPROP_COLOR, color_up);
      ObjectCreate(0, "proj_label_up_" + i, OBJ_TEXT, 0, iTime(NULL, PERIOD_D1, input_start), dayHigh[copied - input_start - 1] + t_range * i * 0.25);
      ObjectSetInteger(0, "proj_label_up_" + i, OBJPROP_COLOR, color_up);
      ObjectSetString(0, "proj_label_up_" + i, OBJPROP_TEXT, DoubleToString(100 + i * 25, 0) + "%");

      ObjectCreate(0, "projections_dn_" + i, OBJ_TREND, 0, iTime(NULL, PERIOD_D1, input_start), dayLow[copied - input_start - 1] - t_range * i * 0.25, iTime(NULL, PERIOD_D1, 0) + PeriodSeconds(PERIOD_D1) *  (1 + input_end), dayLow[copied - input_start - 1] - t_range * i * 0.25);
      ObjectSetInteger(0, "projections_dn_" + i, OBJPROP_COLOR, color_dn);
      ObjectCreate(0, "proj_label_dn_" + i, OBJ_TEXT, 0, iTime(NULL, PERIOD_D1, input_start), dayLow[copied - input_start - 1] - t_range * i * 0.25);
      ObjectSetInteger(0, "proj_label_dn_" + i, OBJPROP_COLOR, color_dn);
      ObjectSetString(0, "proj_label_dn_" + i, OBJPROP_TEXT, DoubleToString(100 + i * 25, 0) + "%");

   }
   int a = 0;

   ChartRedraw();

   return true;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam) {

   if(id == CHARTEVENT_CHART_CHANGE) {
      _lastOK = false;
      CheckTimer();
   }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer() {
   CheckTimer();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckTimer() {
   EventKillTimer();

   if(_updateTimer.Check() || !_lastOK) {
      _lastOK = Update();
      //if (debug) Print("Projections " + " " + _Symbol + ":" + GetTimeFrame(Period()) + " ok");

      EventSetMillisecondTimer(WaitMilliseconds);

      _updateTimer.Reset();
   } else {
      EventSetTimer(1);
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MillisecondTimer {

 private:
   int               _milliseconds;
 private:
   uint              _lastTick;

 public:
   void              MillisecondTimer(const int milliseconds, const bool reset = true) {
      _milliseconds = milliseconds;

      if(reset)
         Reset();
      else
         _lastTick = 0;
   }

 public:
   bool              Check() {
      uint now = getCurrentTick();
      bool stop = now >= _lastTick + _milliseconds;

      if(stop)
         _lastTick = now;

      return(stop);
   }

 public:
   void              Reset() {
      _lastTick = getCurrentTick();
   }

 private:
   uint              getCurrentTick() const {
      return(GetTickCount());
   }

};

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool _lastOK = false;
MillisecondTimer *_updateTimer;
//+------------------------------------------------------------------+

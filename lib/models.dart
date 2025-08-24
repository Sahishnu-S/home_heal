enum Severity {
  minimal,
  mild,
  low, 
  morderate,
  significant,
  high,
  severe, 
  critical,
  dire,
  catastrophic
}

enum Symptoms {
  fatigue,
  headache,
  fever,
  jointPain,
  nausea,
  diarrhea,
  cough,
  runnyOrStuffyNose,
  shortnessOfBreath,
  chestPain,
  dizziness,
  irritation,
  appetiteChanges, 
  sleepDisturbances
}

enum Pains {
  stabbing,
  itchy,
  burning,
  throbbing,
  aching,
  tingling
}

enum Attributes{
  pains, 
  symptoms,
  severity
}

Severity getSeverity(String value){
  switch (value){
    case 'mild': return Severity.mild;
    case 'minimal': return Severity.minimal;
    case 'low': return Severity.low;
    case 'morderate': return Severity.morderate;
    case 'significant': return Severity.significant;
    case 'high': return Severity.high;
    case 'severe': return Severity.severe;
    case 'critical': return Severity.critical;
    case 'dire': return Severity.dire;
    case 'catastrophic': return Severity.catastrophic;
    default: return Severity.mild;
  }
}

double getSeverityNumber(Severity severity){
  switch (severity) {
    case Severity.minimal:
      return 1;
    case Severity.mild:
      return 2;
    case Severity.low:
      return 3;
    case Severity.morderate:
      return 4;
    case Severity.significant:
      return 5;
    case Severity.high:
      return 6;
    case Severity.severe:
      return 7;
    case Severity.critical:
      return 8;
    case Severity.dire:
      return 9;
    case Severity.catastrophic:
      return 10;
  }
}

Severity getSeverityFromDouble(double number){
  switch (number.round()) {
    case 1:
      return Severity.minimal;
    case 2:
      return Severity.mild;
    case 3:
      return Severity.low;
    case 4:
      return Severity.morderate;
    case 5:
      return Severity.significant;
    case 6:
      return Severity.high;
    case 7:
      return Severity.severe;
    case 8:
      return Severity.critical;
    case 9:
      return Severity.dire;
    case 10:
      return Severity.catastrophic;
    default:
      return Severity.mild;
  }
}

Pains getPainType(String value){
  switch (value){
    case 'stabbing': return Pains.stabbing;
    case 'itchy': return Pains.itchy;
    case 'burning': return Pains.burning;
    case 'throbbing': return Pains.throbbing;
    case 'aching': return Pains.aching;
    case 'tingling': return Pains.tingling;
    default: return Pains.aching;
  }
}

Symptoms getSymptomType(String value){
  switch (value) {
    case 'fatigue': return Symptoms.fatigue;
    case 'headache': return Symptoms.headache;
    case 'fever': return Symptoms.fever;
    case 'jointPain': return Symptoms.jointPain;
    case 'nausea': return Symptoms.nausea;
    case 'diarrhea': return Symptoms.diarrhea;
    case 'cough': return Symptoms.cough;
    case 'runnyOrStuffyNose': return Symptoms.runnyOrStuffyNose;
    case 'shortnessOfBreath': return Symptoms.shortnessOfBreath;
    case 'chestPain': return Symptoms.chestPain;
    case 'dizziness': return Symptoms.dizziness;
    case 'irritation': return Symptoms.irritation;
    case 'appetiteChanges': return Symptoms.appetiteChanges;
    case 'sleepDisturbances': return Symptoms.sleepDisturbances;
    default: return Symptoms.fatigue;
  }
}

extension SymptomExtention on Symptoms{
  String formattedSymptom(Symptoms symptom){
    switch (symptom) {
      case Symptoms.fatigue:
      return 'Fatigue';
      case Symptoms.headache:
      return 'Headache';
      case Symptoms.fever:
      return 'Fever';
      case Symptoms.jointPain:
      return 'Joint Pain';
      case Symptoms.nausea:
      return 'Nausea';
      case Symptoms.diarrhea:
      return 'Diarrhea';
      case Symptoms.cough:
      return 'Cough';
      case Symptoms.runnyOrStuffyNose:
      return 'Runny Or Stuffy Nose';
      case Symptoms.shortnessOfBreath:
      return 'Shortness Of Breath';
      case Symptoms.chestPain:
      return 'Chest Pain';
      case Symptoms.dizziness:
      return 'Dizziness';
      case Symptoms.irritation:
      return 'Irritation';
      case Symptoms.appetiteChanges:
      return 'Appetite Changes';
      case Symptoms.sleepDisturbances:
      return 'Sleep Disturbances';
    }
  }
}
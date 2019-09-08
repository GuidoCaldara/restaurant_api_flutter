class MixinValidator{
  String validateInput(String value){
    if( value == null || value.length < 3){
      return 'Please insert a valid location';
    }
  }
}
#include "full_moose_likeApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
full_moose_likeApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

full_moose_likeApp::full_moose_likeApp(InputParameters parameters) : MooseApp(parameters)
{
  full_moose_likeApp::registerAll(_factory, _action_factory, _syntax);
}

full_moose_likeApp::~full_moose_likeApp() {}

void
full_moose_likeApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<full_moose_likeApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"full_moose_likeApp"});
  Registry::registerActionsTo(af, {"full_moose_likeApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
full_moose_likeApp::registerApps()
{
  registerApp(full_moose_likeApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
full_moose_likeApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  full_moose_likeApp::registerAll(f, af, s);
}
extern "C" void
full_moose_likeApp__registerApps()
{
  full_moose_likeApp::registerApps();
}

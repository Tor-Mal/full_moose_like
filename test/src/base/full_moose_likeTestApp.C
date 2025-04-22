//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "full_moose_likeTestApp.h"
#include "full_moose_likeApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
full_moose_likeTestApp::validParams()
{
  InputParameters params = full_moose_likeApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

full_moose_likeTestApp::full_moose_likeTestApp(InputParameters parameters) : MooseApp(parameters)
{
  full_moose_likeTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

full_moose_likeTestApp::~full_moose_likeTestApp() {}

void
full_moose_likeTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  full_moose_likeApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"full_moose_likeTestApp"});
    Registry::registerActionsTo(af, {"full_moose_likeTestApp"});
  }
}

void
full_moose_likeTestApp::registerApps()
{
  registerApp(full_moose_likeApp);
  registerApp(full_moose_likeTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
full_moose_likeTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  full_moose_likeTestApp::registerAll(f, af, s);
}
extern "C" void
full_moose_likeTestApp__registerApps()
{
  full_moose_likeTestApp::registerApps();
}

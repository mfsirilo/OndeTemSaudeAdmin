import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:onde_tem_saude_admin/blocs/contactus_bloc.dart';
import 'package:onde_tem_saude_admin/blocs/city_list_bloc.dart';
import 'package:onde_tem_saude_admin/blocs/service_list_bloc.dart';
import 'package:onde_tem_saude_admin/blocs/specialty_list_bloc.dart';
import 'package:onde_tem_saude_admin/blocs/store_list_bloc.dart';
import 'package:onde_tem_saude_admin/blocs/user_list_bloc.dart';
import 'package:onde_tem_saude_admin/globals.dart';
import 'package:onde_tem_saude_admin/ui/pages/city_page.dart';
import 'package:onde_tem_saude_admin/ui/pages/service_page.dart';
import 'package:onde_tem_saude_admin/ui/pages/specialty_page.dart';
import 'package:onde_tem_saude_admin/ui/pages/store_page.dart';
import 'package:onde_tem_saude_admin/ui/pages/user_page.dart';
import 'package:onde_tem_saude_admin/ui/tabs/contactus_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/city_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/services_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/specialties_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/stores_tab.dart';
import 'package:onde_tem_saude_admin/ui/tabs/users_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 0;

  UserListBloc _userBloc;
  StoreListBloc _storesBloc;
  CityListBloc _cityBloc;
  SpecialtyListBloc _specialtyBloc;
  ServiceListBloc _serviceBloc;
  ContactUsBloc _contactUsBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _userBloc = UserListBloc();
    _storesBloc = StoreListBloc();
    _cityBloc = CityListBloc();
    _specialtyBloc = SpecialtyListBloc();
    _serviceBloc = ServiceListBloc();
    _contactUsBloc = ContactUsBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).primaryColor,
              primaryColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.white54))),
          child: BottomNavigationBar(
              currentIndex: _page,
              onTap: (p) {
                _pageController.animateToPage(p,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              },
              items: _getBottomItems())),
      body: SafeArea(
        child: BlocProvider<UserListBloc>(
          bloc: _userBloc,
          child: BlocProvider<StoreListBloc>(
            bloc: _storesBloc,
            child: BlocProvider<CityListBloc>(
              bloc: _cityBloc,
              child: BlocProvider<SpecialtyListBloc>(
                bloc: _specialtyBloc,
                child: BlocProvider<ServiceListBloc>(
                  bloc: _serviceBloc,
                  child: BlocProvider<ContactUsBloc>(
                    bloc: _contactUsBloc,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (p) {
                        setState(() {
                          _page = p;
                        });
                      },
                      children: _getPages(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  List<Widget> _getPages() {
    var itens = [
      ContactUsTab(),
      StoresTab(),
      SpecialtiesTab(),
      ServicesTab(),
      UsersTab()
    ];

    if (isAdmin) itens.add(CityTab());

    return itens;
  }

  List<BottomNavigationBarItem> _getBottomItems() {
    var itens = [
      BottomNavigationBarItem(
          icon: Icon(Icons.message), title: Text("Mensagens")),
      BottomNavigationBarItem(
          icon: Icon(Icons.local_hospital), title: Text("Uni. Saúde")),
      BottomNavigationBarItem(
          icon: Icon(Icons.category), title: Text("Especialidades")),
      BottomNavigationBarItem(
          icon: Icon(Icons.room_service), title: Text("Serviços")),
      BottomNavigationBarItem(
          icon: Icon(Icons.person), title: Text("Munícipe")),
    ];

    if (isAdmin)
      itens.add(BottomNavigationBarItem(
          icon: Icon(Icons.location_on), title: Text("Cidades")));

    return itens;
  }

  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return Container();
      case 1:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => StorePage()));
          },
        );
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SpecialtyPage()));
          },
        );
      case 3:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ServicePage()));
          },
        );
      case 4:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UserPage()));
          },
        );
      case 5:
        if (isAdmin) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CityPage()));
            },
          );
        } else {
          return Container();
        }
        break;
      default:
        return Container();
    }
  }
}

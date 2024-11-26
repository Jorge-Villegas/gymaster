import 'package:gymaster/core/database/database_helper.dart';
import 'package:gymaster/core/database/models/ejercicio.dart';
import 'package:gymaster/core/database/models/ejercicio_musculo.dart';
import 'package:gymaster/core/database/models/musculo.dart';
import 'package:gymaster/core/generated/assets.gen.dart';
import 'package:gymaster/shared/utils/logger.dart';

class EjercicioDataSeed {
  List<Ejercicio> trapecio = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Encogimiento de hombros con Barra de Pesas',
      descripcion:
          'Este ejercicio se realiza sosteniendo una barra con peso en frente del cuerpo y elevando los hombros hacia las orejas, manteniendo los brazos rectos. Es importante mantener la espalda recta y los hombros hacia abajo y atrás al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.trapecio.encogimientoDeHombrosConBarraDePesas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Encogimiento de Hombros con Barra de Pesas detrás de la Espalda',
      descripcion:
          'En este ejercicio, se sostiene una barra con peso detrás del cuerpo y se elevan los hombros hacia las orejas, manteniendo los brazos rectos. Es fundamental mantener una postura erguida y los hombros hacia abajo y atrás al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.trapecio
          .encogimientoDeHombrosConBarraDePesasDetrasDeLaEspalda.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Encogimiento de Hombros con Mancuernas (de pie)',
      descripcion:
          'Este ejercicio se realiza de pie, sosteniendo una mancuerna en cada mano a los costados del cuerpo. Se elevan los hombros hacia las orejas y se contraen los músculos del trapecio. Es importante mantener una postura erguida y los hombros hacia abajo y atrás al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.trapecio
          .encogimientoDeHombrosConMancuernasDePie.path,
    ),
    Ejercicio(
        id: DatabaseHelper.instance.generateUUID(),
        nombre: 'Encogimiento de Hombros con Maquina (sentado)',
        imagenDireccion: Assets.imagenes.musculos.trapecio
            .encogimientoDeHombrosConMaquinaSentado.path,
        descripcion:
            'En este ejercicio, se utiliza una máquina diseñada para el encogimiento de hombros. Sentado en la máquina, se agarra las asas y se elevan los hombros hacia las orejas, manteniendo los brazos rectos. Se contraen los músculos del trapecio al final del movimiento.'),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Encogimiento de Hombros detrás de la espalda con maquina smith (de pie)',
      imagenDireccion: Assets.imagenes.musculos.trapecio
          .encogimientoDeHombrosDetrasDeLaEspaldaConMaquinaSmithDePie.path,
      descripcion:
          'Este ejercicio se realiza de pie, utilizando la máquina smith. Se coloca la barra detrás del cuerpo y se elevan los hombros hacia las orejas, manteniendo los brazos rectos. Al final del movimiento, se contraen los músculos del trapecio.',
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Encogimiento de hombros en la maquina smith (de pie)',
      imagenDireccion: Assets.imagenes.musculos.trapecio
          .encogimientoDeHombrosEnLaMaquinaSmithDePie.path,
      descripcion:
          'En este ejercicio, se utiliza la máquina smith para realizar el encogimiento de hombros. De pie frente a la máquina, se agarra la barra y se elevan los hombros hacia las orejas, manteniendo los brazos rectos. Se contraen los músculos del trapecio al final del movimiento.',
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo vertical con barra de pesas (de pie)',
      imagenDireccion: Assets
          .imagenes.musculos.trapecio.remoVerticalConBarraDePesasDePie.path,
      descripcion:
          'Este ejercicio se realiza de pie, sosteniendo una barra con peso en frente del cuerpo con las palmas hacia abajo. Se eleva la barra verticalmente hacia el mentón, manteniendo los codos altos. Se contraen los músculos del trapecio al final del movimiento.',
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo vertical con cable-polea (de pie)',
      imagenDireccion:
          Assets.imagenes.musculos.trapecio.remoVerticalConCablePoleaDePie.path,
      descripcion:
          'En este ejercicio, se utiliza una máquina de poleas para realizar el remo vertical. De pie frente a la máquina, se agarra la polea con las manos y se eleva hacia el mentón, manteniendo los codos altos. Se contraen los músculos del trapecio al final del movimiento.',
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo vertical con mancuerna (de pie)',
      imagenDireccion:
          Assets.imagenes.musculos.trapecio.remoVerticalConMancuernaDePie.path,
      descripcion:
          'Este ejercicio se realiza de pie, sosteniendo una mancuerna en cada mano a los costados del cuerpo. Se eleva la mancuerna verticalmente hacia el mentón, manteniendo los codos altos. Se contraen los músculos del trapecio al final del movimiento.',
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo vertical con máquina smith (de pie)',
      imagenDireccion: Assets
          .imagenes.musculos.trapecio.remoVerticalConMaquinaSmithDePie.path,
      descripcion:
          'En este ejercicio, se utiliza la máquina smith para realizar el remo vertical. De pie frente a la máquina, se agarra la barra y se eleva hacia el mentón, manteniendo los codos altos. Se contraen los músculos del trapecio al final del movimiento.',
    ),
  ];

  List<Ejercicio> ejerciciosHombro = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura con maquina invertida (acostado)',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.aperturaConMaquinaInvertidaAcostado.path,
      descripcion:
          'Este ejercicio se realiza acostado en una máquina de pecho invertida. Se agarra las asas con los brazos extendidos y se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura con maquina invertida (sentado)',
      descripcion:
          'En este ejercicio, se utiliza una máquina de pecho invertida mientras se está sentado. Se agarra las asas con los brazos extendidos y se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.aperturaConMaquinaInvertidaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Aperturas en Banco plano con mancuernas invertidas (prono)',
      descripcion:
          'Este ejercicio se realiza acostado en un banco plano con una mancuerna en cada mano, los brazos extendidos hacia abajo. Se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.hombro
          .aperturasEnBancoPlanoConMancuernasInvertidasProno.path,
    ),
    Ejercicio(
        id: DatabaseHelper.instance.generateUUID(),
        nombre: 'Flexiones de pecho parado sobre la cabeza',
        descripcion:
            'En este ejercicio, se realizan flexiones de pecho con los pies elevados y las manos colocadas en el suelo directamente debajo de los hombros. Se baja el cuerpo hacia el suelo doblando los codos y luego se empuja de vuelta a la posición inicial.',
        imagenDireccion: Assets
            .imagenes.musculos.hombro.flexionesDePechoParadoSobreLaCabeza.path),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento frontal con barra de pesas (de pie)',
      descripcion:
          'Este ejercicio se realiza de pie, sosteniendo una barra con peso con las palmas hacia abajo y los brazos extendidos hacia abajo. Se eleva la barra verticalmente hacia el frente, manteniendo los codos ligeramente flexionados. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.hombro
          .levantamientoFrontalConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento frontal con cuerda y cable-polea (de pie)',
      descripcion:
          'En este ejercicio, se utiliza una máquina de poleas con una cuerda. De pie frente a la máquina, se agarra la cuerda con las manos y se eleva hacia el frente, manteniendo los codos ligeramente flexionados. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.hombro
          .levantamientoFrontalConCuerdaYCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento Frontal con disco (de pie)',
      descripcion:
          'Este ejercicio se realiza de pie, sosteniendo un disco con ambas manos y los brazos extendidos hacia abajo. Se eleva el disco verticalmente hacia el frente, manteniendo los codos ligeramente flexionados. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.levantamientoFrontalConDiscoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento Frontal con mancuerna (de pie)',
      descripcion:
          'En este ejercicio, se realiza de pie, sosteniendo una mancuerna en cada mano con los brazos extendidos hacia abajo. Se elevan las mancuernas verticalmente hacia el frente, manteniendo los codos ligeramente flexionados. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.levantamientoFrontalConMancuernaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento Frontal con un brazo en cable-polea (de pie)',
      descripcion:
          'Este ejercicio se realiza de pie frente a una máquina de poleas con un solo brazo. Se agarra la polea con una mano y se eleva hacia el frente, manteniendo el codo ligeramente flexionado. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.hombro
          .levantamientoFrontalConUnBrazoEnCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Levantamiento Frontal con Cable-Polea en un solo brazo (inclinado)',
      descripcion:
          'En este ejercicio, se utiliza una máquina de poleas con un solo brazo mientras se está inclinado hacia adelante. Se agarra la polea con una mano y se eleva hacia el frente, manteniendo el codo ligeramente flexionado. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.hombro
          .levantamientoFrontalConCablePoleaEnUnSoloBrazoInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento lateral con mancuernas (de pie)',
      descripcion:
          'Este ejercicio se realiza de pie, sosteniendo una mancuerna en cada mano a los costados del cuerpo. Se elevan las mancuernas hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.levantamientoLateralConMancuernasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento lateral con mancuernas (inclinado)',
      descripcion:
          'En este ejercicio, se realiza de pie, inclinándose ligeramente hacia adelante. Se sostiene una mancuerna en cada mano y se elevan hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.hombro
          .levantamientoLateralConMancuernasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento lateral con maquina (sentado)',
      descripcion:
          'Este ejercicio se realiza sentado en una máquina de levantamiento lateral. Se agarra las asas con los brazos extendidos hacia abajo y se elevan hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.levantamientoLateralConMaquinaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de cuello con barra de pesas (de pie)',
      descripcion:
          'En este ejercicio, se realiza de pie, sosteniendo una barra con peso detrás de la cabeza. Se eleva la barra verticalmente hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.pressDeCuelloConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de hombros con barra de pesas (de pie)',
      descripcion:
          'Este ejercicio se realiza de pie, sosteniendo una barra con peso a la altura de los hombros con los brazos flexionados. Se eleva la barra verticalmente hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.pressDeHombrosConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de hombros con mancuernas (sentado)',
      descripcion:
          'En este ejercicio, se realiza sentado en un banco con respaldo. Se sostiene una mancuerna en cada mano a la altura de los hombros con los codos flexionados. Se elevan las mancuernas verticalmente hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.pressDeHombrosConMancuernasSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de hombros con maquina (sentado)',
      descripcion:
          'Este ejercicio se realiza sentado en una máquina de press de hombros. Se agarra las asas con los brazos flexionados a la altura de los hombros. Se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.hombro.pressDeHombrosConMaquinaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de hombros con maquina smith (sentado)',
      descripcion:
          'En este ejercicio, se realiza sentado en la máquina smith. Se agarra la barra con los brazos flexionados a la altura de los hombros. Se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.pressDeHombrosConMaquinaSmithSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho con barra de pesas (inclinado)',
      descripcion:
          'Este ejercicio se realiza en un banco inclinado, sosteniendo una barra con peso a la altura de los hombros con los brazos flexionados. Se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del hombro al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.pressDePechoConBarraDePesasInclinado.path,
    ),
    Ejercicio(
        id: DatabaseHelper.instance.generateUUID(),
        nombre: 'Remo vertical con barra de pesas (de pie)',
        descripcion:
            'Este ejercicio se realiza de pie, sosteniendo una barra con peso en frente del cuerpo con las palmas hacia abajo. Se eleva la barra verticalmente hacia el mentón, manteniendo los codos altos. Se contraen los músculos del trapecio al final del movimiento.',
        imagenDireccion: Assets
            .imagenes.musculos.hombro.remoVerticalConBarraDePesasDePie.path),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo vertical con cable-polea (de pie)',
      descripcion:
          'En este ejercicio, se utiliza una máquina de poleas para realizar el remo vertical. De pie frente a la máquina, se agarra la polea con las manos y se eleva hacia el mentón, manteniendo los codos altos. Se contraen los músculos del trapecio al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.hombro.remoVerticalConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo vertical con mancuernas (de pie)',
      descripcion:
          'Este ejercicio se realiza de pie, sosteniendo una mancuerna en cada mano a los costados del cuerpo. Se eleva la mancuerna verticalmente hacia el mentón, manteniendo los codos altos. Se contraen los músculos del trapecio al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.hombro.remoVerticalConMancuernasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo vertical con maquina de smith (de pie)',
      descripcion:
          'En este ejercicio, se utiliza la máquina smith para realizar el remo vertical. De pie frente a la máquina, se agarra la barra y se eleva hacia el mentón, manteniendo los codos altos. Se contraen los músculos del trapecio al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.hombro.remoVerticalConMaquinaDeSmithDePie.path,
    ),
  ];

  List<Ejercicio> ejerciciosPecho = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura con maquina (sentado)',
      descripcion:
          'Este ejercicio se realiza sentado en una máquina de apertura de pecho. Se agarra las asas con los brazos extendidos y se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.aperturaConMaquinaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura con mancuernas (declinado)',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco declinado con una mancuerna en cada mano. Se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.aperturaConMancuernasDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura con mancuernas (inclinado)',
      descripcion:
          'Este ejercicio se realiza acostado en un banco inclinado con una mancuerna en cada mano. Se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.aperturaConMancuernasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura con mancuernas en plano',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco plano con una mancuerna en cada mano. Se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.aperturaConMancuernasEnPlano.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura de banco plano con cable-polea',
      descripcion:
          'Este ejercicio se realiza acostado en un banco plano frente a una máquina de poleas. Se agarra las asas con los brazos extendidos y se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.aperturaDeBancoPlanoConCablePolea.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura de banco plano con mancuernas girando',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco plano con una mancuerna en cada mano. Se abren los brazos hacia los lados mientras se gira las muñecas hacia adentro, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .aperturaDeBancoPlanoConMancuernasGirando.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura de banco plano con cable-polea (declinado)',
      descripcion:
          'Este ejercicio se realiza acostado en un banco plano frente a una máquina de poleas. Se agarra las asas con los brazos extendidos y se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .aperturaDeBancoPlanoConCablePoleaDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura de banco plano con cable-polea (inclinado)',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco plano frente a una máquina de poleas. Se agarra las asas con los brazos extendidos y se abren los brazos hacia los lados, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .aperturaDeBancoPlanoConCablePoleaInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura en banco con mancuernas girando (declinado)',
      descripcion:
          'Este ejercicio se realiza acostado en un banco declinado con una mancuerna en cada mano. Se abren los brazos hacia los lados mientras se gira las muñecas hacia adentro, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .aperturaEnBancoConMancuernasGirandoDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Apertura en banco con mancuernas girando (inclinado)',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco inclinado con una mancuerna en cada mano. Se abren los brazos hacia los lados mientras se gira las muñecas hacia adentro, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .aperturaEnBancoConMancuernasGirandoInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Barra paralela en maquina sostenidas',
      descripcion:
          'Este ejercicio se realiza utilizando una máquina de barra paralela. Se agarra la barra con los brazos extendidos y se empuja hacia arriba, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.barraParalelaEnMaquinaSostenidas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Barra paralelas, inclinado, agarre amplio',
      descripcion:
          'En este ejercicio, se realiza utilizando una máquina de barra paralela mientras se está inclinado hacia adelante. Se agarra la barra con los brazos extendidos y se empuja hacia arriba, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.barraParalelasInclinadoAgarreAmplio.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'barra paralelas, inclinados',
      descripcion:
          'Este ejercicio se realiza utilizando una máquina de barra paralela mientras se está inclinado hacia adelante. Se agarra la barra con los brazos extendidos y se empuja hacia arriba, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.barraParalelasInclinados.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Cruzada con Cable-Polea (de pie)',
      descripcion:
          'En este ejercicio, se utiliza una máquina de cable-polea con un agarre cruzado. Se agarra las asas con los brazos extendidos y se cruzan los brazos frente al cuerpo, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.cruzadaConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de pecho con mancuernas (declinado)',
      descripcion:
          'Este ejercicio se realiza con las manos apoyadas en el suelo y una mancuerna en cada mano. Se baja el cuerpo hacia el suelo doblando los codos y luego se empuja de vuelta a la posición inicial. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.flexionesDePechoConMancuernasDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de pecho con mancuernas (inclinado)',
      descripcion:
          'En este ejercicio, se realiza con las manos apoyadas en el suelo y una mancuerna en cada mano. Se baja el cuerpo hacia el suelo doblando los codos y luego se empuja de vuelta a la posición inicial. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.flexionesDePechoConMancuernasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de pecho en plano con mancuernas',
      descripcion:
          'Este ejercicio se realiza con las manos apoyadas en el suelo y una mancuerna en cada mano. Se baja el cuerpo hacia el suelo doblando los codos y luego se empuja de vuelta a la posición inicial. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.flexionesDePechoEnPlanoConMancuernas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de pecho, agarre amplio',
      descripcion:
          'En este ejercicio, se realiza con las manos apoyadas en el suelo y se separan más anchas que los hombros. Se baja el cuerpo hacia el suelo doblando los codos y luego se empuja de vuelta a la posición inicial. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.flexionesDePechoAgarreAmplio.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de pecho, agarre amplio (declinado)',
      descripcion:
          'Este ejercicio se realiza con las manos apoyadas en el suelo y se separan más anchas que los hombros. Se baja el cuerpo hacia el suelo doblando los codos y luego se empuja de vuelta a la posición inicial. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.flexionesDePechoAgarreAmplioDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Hala con cable-polea y brazo recto (de pie)',
      descripcion:
          'En este ejercicio, se utiliza una máquina de cable-polea con una sola mano. Se agarra la polea con una mano y se tira hacia abajo y hacia el cuerpo, manteniendo el brazo recto. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.halaConCablePoleaYBrazoRectoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Mariposa con maquinas (sentado)',
      descripcion:
          'Este ejercicio se realiza sentado en una máquina de mariposa. Se agarra las asas con los brazos flexionados y se juntan las manos frente al cuerpo, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.mariposaConMaquinasSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho frontal con maquina (sentado)',
      descripcion:
          'En este ejercicio, se realiza sentado en una máquina de press de pecho frontal. Se agarra las asas con los brazos extendidos y se empuja hacia adelante, manteniendo los codos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoFrontalConMaquinaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho plano con barra de pesas',
      descripcion:
          'Este ejercicio se realiza acostado en un banco plano con una barra con peso en las manos. Se empuja la barra hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pressDePechoPlanoConBarraDePesas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho plano con barra de pesas, agarre amplio',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco plano con una barra con peso en las manos. Se empuja la barra hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .pressDePechoPlanoConBarraDePesasAgarreAmplio.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Press de pecho plano con barra de pesas, agarre amplio (declinado)',
      descripcion:
          'Este ejercicio se realiza acostado en un banco plano con una barra con peso en las manos. Se empuja la barra hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .pressDePechoPlanoConBarraDePesasAgarreAmplioDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Press de pecho plano con barra de pesas, agarre amplio (inclinado)',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco plano con una barra con peso en las manos. Se empuja la barra hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .pressDePechoPlanoConBarraDePesasAgarreAmplioInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho plano con maquina',
      descripcion:
          'Este ejercicio se realiza acostado en una máquina de press de pecho. Se agarra las asas con los brazos extendidos y se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pressDePechoPlanoConMaquina.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho plano con maquina smith',
      descripcion:
          'En este ejercicio, se realiza acostado en la máquina smith. Se agarra la barra con los brazos extendidos y se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pressDePechoPlanoConMaquinaSmith.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho plano con maquina smith, agarre amplio',
      descripcion:
          'Este ejercicio se realiza acostado en la máquina smith. Se agarra la barra con los brazos extendidos y se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .pressDePechoPlanoConMaquinaSmithAgarreAmplio.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho con barra de pesas (declinado)',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco declinado con una barra con peso en las manos. Se empuja la barra hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoConBarraDePesasDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho con barra de pesas (inclinado)',
      descripcion:
          'Este ejercicio se realiza acostado en un banco inclinado con una barra con peso en las manos. Se empuja la barra hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoConBarraDePesasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho con maquina smith (declinado)',
      descripcion:
          'En este ejercicio, se realiza acostado en la máquina smith en un banco declinado. Se agarra la barra con los brazos extendidos y se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoConMaquinaSmithDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho con maquina smith (inclinado)',
      descripcion:
          'Este ejercicio se realiza acostado en la máquina smith en un banco inclinado. Se agarra la barra con los brazos extendidos y se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoConMaquinaSmithInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho con maquina smith, agarre amplio (declinado)',
      descripcion:
          'En este ejercicio, se realiza acostado en la máquina smith en un banco declinado. Se agarra la barra con los brazos extendidos y se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .pressDePechoConMaquinaSmithAgarreAmplioDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de pecho con maquina smith, agarre amplio (inclinado)',
      descripcion:
          'Este ejercicio se realiza acostado en la máquina smith en un banco inclinado. Se agarra la barra con los brazos extendidos y se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .pressDePechoConMaquinaSmithAgarreAmplioInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press en banco plano con mancuernas en agarre de martillo',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco plano con una mancuerna en cada mano. Se empujan las mancuernas hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .pressEnBancoPlanoConMancuernasEnAgarreDeMartillo.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press en banco con mancuernas en agarre de martillo (declinado)',
      descripcion:
          'Este ejercicio se realiza acostado en un banco declinado con una mancuerna en cada mano. Se empujan las mancuernas hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .pressEnBancoConMancuernasEnAgarreDeMartilloDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press en banco con mancuernas en agarre de martillo (inclinado)',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco inclinado con una mancuerna en cada mano. Se empujan las mancuernas hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pecho
          .pressEnBancoConMancuernasEnAgarreDeMartilloInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press en banco con maquina (declinado)',
      descripcion:
          'Este ejercicio se realiza acostado en una máquina de press de pecho en un banco declinado. Se agarra las asas con los brazos extendidos y se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pressEnBancoConMaquinaDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press en banco con maquina (inclinado)',
      descripcion:
          'En este ejercicio, se realiza acostado en una máquina de press de pecho en un banco inclinado. Se agarra las asas con los brazos extendidos y se empuja hacia arriba, extendiendo los brazos completamente. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pressEnBancoConMaquinaInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Pullover en banco plano con barra de pesas',
      descripcion:
          'Este ejercicio se realiza acostado en un banco plano con una barra con peso por encima de la cabeza. Se baja la barra detrás de la cabeza, manteniendo los brazos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pulloverEnBancoPlanoConBarraDePesas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Pullover en banco plano con Cable-Polea',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco plano frente a una máquina de poleas. Se agarra la polea con las manos y se baja el cable detrás de la cabeza, manteniendo los brazos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pulloverEnBancoPlanoConCablePolea.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Pullover en Banco plano con Maquinas',
      descripcion:
          'Este ejercicio se realiza acostado en un banco plano frente a una máquina de pullover. Se agarra las asas con los brazos extendidos y se baja el cable detrás de la cabeza, manteniendo los brazos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pulloverEnBancoPlanoConMaquinas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Pullover en plano con Barra EZ',
      descripcion:
          'En este ejercicio, se realiza acostado en un banco plano con una barra EZ con peso por encima de la cabeza. Se baja la barra detrás de la cabeza, manteniendo los brazos ligeramente flexionados. Se contraen los músculos del pecho al final del movimiento.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pulloverEnPlanoConBarraEz.path,
    ),
  ];

  List<Ejercicio> ejerciciosTriceps = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Arrastre de concentración de tríceps con Cable-Polea (arrodillado)',
      descripcion:
          'Siéntate frente a una máquina de polea con cable con la pierna opuesta a la mano que sujetará el cable. Sujeta el cable con la mano del mismo lado del tríceps que trabajarás, mantén el codo fijo y realiza una extensión completa del brazo hacia abajo, contrayendo el tríceps. Luego, regresa a la posición inicial controladamente.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .arrastreDeConcentracionDeTricepsConCablePoleaArrodillado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Arrastre de tríceps con Cable-Polea Agarre por Debajo (sentado)',
      descripcion:
          'Siéntate en un banco frente a una máquina de polea con cable con los pies bien apoyados en el suelo. Agarra la barra o la cuerda de la polea con ambas manos en pronación, manteniendo los codos pegados al cuerpo. Extiende los brazos hacia abajo hasta que estén completamente extendidos y luego flexiona los codos para llevar la barra o la cuerda hacia arriba, contrayendo los tríceps. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .arrastreDeTricepsConCablePoleaAgarrePorDebajoSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Barra, Agarre Ancho',
      descripcion:
          'De pie, sostén una barra con las manos separadas a una distancia mayor que el ancho de los hombros. Eleva la barra hasta que los brazos estén completamente extendidos, manteniendo los codos cerca del cuerpo. Luego, flexiona los codos para bajar la barra detrás de la cabeza, manteniendo los codos en su lugar. Finalmente, extiende los brazos para volver a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.triceps.barraAgarreAncho.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Pecho con Mancuernas (declinado)',
      descripcion:
          'Colócate en posición de flexión con los pies elevados en un banco y las manos sosteniendo un par de mancuernas. Mantén el cuerpo recto y baja el pecho hacia el suelo doblando los codos, manteniendo los codos cerca del cuerpo. Luego, empuja hacia arriba para volver a la posición inicial, extendiendo los brazos.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.flexionesDePechoConMancuernasDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Pecho con Mancuernas (inclinado)',
      descripcion:
          'Colócate en posición de flexión con los pies apoyados en el suelo y las manos sosteniendo un par de mancuernas. Mantén el cuerpo recto y baja el pecho hacia el suelo doblando los codos, manteniendo los codos cerca del cuerpo. Luego, empuja hacia arriba para volver a la posición inicial, extendiendo los brazos.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.flexionesDePechoConMancuernasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Pecho en Plano con Mancuernas',
      descripcion:
          'Colócate en posición de flexión con los pies apoyados en el suelo y las manos sosteniendo un par de mancuernas. Mantén el cuerpo recto y baja el pecho hacia el suelo doblando los codos, manteniendo los codos cerca del cuerpo. Luego, empuja hacia arriba para volver a la posición inicial, extendiendo los brazos.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.flexionesDePechoEnPlanoConMancuernas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Pecho, Agarre Cerrado',
      descripcion:
          'Colócate en posición de flexión con las manos cerca una de la otra, formando un triángulo con los pulgares y los índices. Mantén el cuerpo recto y baja el pecho hacia el suelo doblando los codos, manteniendo los codos cerca del cuerpo. Luego, empuja hacia arriba para volver a la posición inicial, extendiendo los brazos.',
      imagenDireccion:
          Assets.imagenes.musculos.triceps.flexionesDePechoAgarreCerrado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquina de tríceps con Cable-Polea (acostado)',
      descripcion:
          'Recuéstate en un banco plano debajo de una máquina de polea con cable. Agarra la barra o la cuerda con ambas manos en pronación, manteniendo los codos cerca del cuerpo. Extiende los brazos hacia arriba, contrayendo los tríceps, y luego flexiona los codos para bajar la barra o la cuerda hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets
          .imagenes.musculos.triceps.maquinaDeTricepsConCablePoleaAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquina de tríceps con Cable-Polea (inclinado)',
      descripcion:
          'Siéntate en un banco inclinado frente a una máquina de polea con cable con los pies apoyados en el suelo. Agarra la barra o la cuerda con ambas manos en pronación, manteniendo los codos cerca del cuerpo. Extiende los brazos hacia arriba, contrayendo los tríceps, y luego flexiona los codos para bajar la barra o la cuerda hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .maquinaDeTricepsConCablePoleaInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Paralelas con Maquina Sostenida',
      descripcion:
          'Agarra las barras paralelas de una máquina de dip y sostén tu peso con los brazos extendidos y el cuerpo vertical. Flexiona los codos para bajar el cuerpo hacia abajo, manteniendo los codos cerca del cuerpo. Luego, extiende los brazos para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.triceps.paralelasConMaquinaSostenida.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Paralelas, Piernas Levantadas',
      descripcion:
          'Suspende tu cuerpo sosteniéndote en las barras paralelas con los brazos extendidos y las piernas levantadas en posición horizontal. Flexiona los codos para bajar el cuerpo hacia abajo, manteniendo los codos cerca del cuerpo. Luego, extiende los brazos para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.triceps.paralelasPiernasLevantadas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Patada de tríceps con Cable-Polea (inclinado)',
      descripcion:
          'Siéntate en un banco inclinado frente a una máquina de polea con cable con los pies apoyados en el suelo. Agarra la barra o la cuerda con una mano y apoya el codo de la misma mano en el banco. Extiende el brazo hacia abajo, manteniendo el codo fijo, y luego flexiona el codo para llevar la barra o la cuerda hacia arriba, contrayendo el tríceps. Controla el movimiento en todo momento.',
      imagenDireccion: Assets
          .imagenes.musculos.triceps.patadaDeTricepsConCablePoleaInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Patada de tríceps con Mancuernas (inclinado)',
      descripcion:
          'Siéntate en un banco inclinado con una mancuerna en una mano y apoya el codo de la misma mano en el banco. Extiende el brazo hacia abajo, manteniendo el codo fijo, y luego flexiona el codo para llevar la mancuerna hacia arriba, contrayendo el tríceps. Controla el movimiento en todo momento.',
      imagenDireccion: Assets
          .imagenes.musculos.triceps.patadaDeTricepsConMancuernasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press tate de tríceps con Mancuernas (acostado)',
      descripcion:
          'Recuéstate en un banco plano con una mancuerna en cada mano, sosteniéndolas por encima del pecho con los brazos extendidos y los codos ligeramente flexionados. Baja las mancuernas hacia los lados de la cabeza doblando los codos, manteniendo los codos fijos. Luego, extiende los brazos para volver a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressTateDeTricepsConMancuernasAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press con Barra de pesas en maquina smith, agarre cerrado',
      descripcion:
          'Colócate debajo de una barra en una máquina Smith con un agarre cerrado, con las manos separadas a una distancia menor que el ancho de los hombros. Levanta la barra y extiende los brazos hacia arriba, manteniendo los codos cerca del cuerpo. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressConBarraDePesasEnMaquinaSmithAgarreCerrado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Press con Barra de pesas en maquina smith, agarre cerrado (declinado)',
      descripcion:
          'Colócate debajo de una barra en una máquina Smith con un agarre cerrado, con las manos separadas a una distancia menor que el ancho de los hombros. Levanta la barra y extiende los brazos hacia arriba, manteniendo los codos cerca del cuerpo. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressConBarraDePesasEnMaquinaSmithAgarreCerradoDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Press con Barra de pesas en maquina smith, agarre cerrado (inclinado)',
      descripcion:
          'Colócate debajo de una barra en una máquina Smith con un agarre cerrado, con las manos separadas a una distancia menor que el ancho de los hombros. Levanta la barra y extiende los brazos hacia arriba, manteniendo los codos cerca del cuerpo. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressConBarraDePesasEnMaquinaSmithAgarreCerradoInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Pecho Frontal con Maquina (sentado)',
      descripcion:
          'Siéntate en una máquina de prensa de pecho con los pies firmemente apoyados en el suelo y la espalda bien apoyada en el respaldo. Agarra las asas de la máquina con las manos y empuja hacia adelante para extender los brazos, manteniendo los codos ligeramente flexionados. Luego, controladamente, regresa los brazos a la posición inicial flexionando los codos.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoFrontalConMaquinaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Pecho Plano con Barra de Pesas',
      descripcion:
          'Acuéstate en un banco plano con los pies apoyados en el suelo y agarra la barra con las manos separadas a una distancia mayor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos, manteniendo los codos ligeramente flexionados. Luego, controladamente, baja la barra hacia el pecho doblando los codos. Finalmente, empuja la barra hacia arriba para volver a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pressDePechoPlanoConBarraDePesas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Pecho Plano con Maquina Smith',
      descripcion:
          'Acuéstate en un banco plano debajo de una máquina Smith con los pies apoyados en el suelo y agarra la barra con las manos separadas a una distancia mayor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos, manteniendo los codos ligeramente flexionados. Luego, controladamente, baja la barra hacia el pecho doblando los codos. Finalmente, empuja la barra hacia arriba para volver a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.pecho.pressDePechoPlanoConMaquinaSmith.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Pecho con Barra de Pesas (declinado)',
      descripcion:
          'Acuéstate en un banco declinado con los pies apoyados en el suelo y agarra la barra con las manos separadas a una distancia mayor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos, manteniendo los codos ligeramente flexionados. Luego, controladamente, baja la barra hacia el pecho doblando los codos. Finalmente, empuja la barra hacia arriba para volver a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoConBarraDePesasDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Pecho con Barra de Pesas (inclinado)',
      descripcion:
          'Acuéstate en un banco inclinado con los pies apoyados en el suelo y agarra la barra con las manos separadas a una distancia mayor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos, manteniendo los codos ligeramente flexionados. Luego, controladamente, baja la barra hacia el pecho doblando los codos. Finalmente, empuja la barra hacia arriba para volver a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoConBarraDePesasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Pecho con Maquina Smith (declinado)',
      descripcion:
          'Acuéstate en un banco declinado debajo de una máquina Smith con los pies apoyados en el suelo y agarra la barra con las manos separadas a una distancia mayor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos, manteniendo los codos ligeramente flexionados. Luego, controladamente, baja la barra hacia el pecho doblando los codos. Finalmente, empuja la barra hacia arriba para volver a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoConMaquinaSmithDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Pecho con Maquina Smith (inclinado)',
      descripcion:
          'Acuéstate en un banco inclinado debajo de una máquina Smith con los pies apoyados en el suelo y agarra la barra con las manos separadas a una distancia mayor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos, manteniendo los codos ligeramente flexionados. Luego, controladamente, baja la barra hacia el pecho doblando los codos. Finalmente, empuja la barra hacia arriba para volver a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.pecho.pressDePechoConMaquinaSmithInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps Frances con Barra EZ (acostado)',
      descripcion:
          'Recuéstate en un banco plano con los pies apoyados en el suelo y agarra una barra EZ con las manos en pronación, separadas a una distancia menor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos hacia arriba, manteniendo los codos fijos. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsFrancesConBarraEzAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps Frances con Barra EZ (declinado)',
      descripcion:
          'Recuéstate en un banco declinado con los pies apoyados en el suelo y agarra una barra EZ con las manos en pronación, separadas a una distancia menor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos hacia arriba, manteniendo los codos fijos. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsFrancesConBarraEzDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps Frances con Barra EZ (inclinado)',
      descripcion:
          'Recuéstate en un banco inclinado con los pies apoyados en el suelo y agarra una barra EZ con las manos en pronación, separadas a una distancia menor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos hacia arriba, manteniendo los codos fijos. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsFrancesConBarraEzInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Press de Tríceps Frances con Barra EZ, Agarre por Abajo (acostado)',
      descripcion:
          'Recuéstate en un banco plano con los pies apoyados en el suelo y agarra una barra EZ con las manos en supinación, separadas a una distancia mayor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos hacia arriba, manteniendo los codos fijos. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsFrancesConBarraEzAgarrePorAbajoAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps con Barra EZ por Arriba (sentado)',
      descripcion:
          'Siéntate en un banco con la espalda recta y agarra una barra EZ con las manos en pronación, separadas a una distancia mayor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos hacia arriba, manteniendo los codos fijos. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsConBarraEzPorArribaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps con Cable-Polea por Arriba (arrodillado)',
      descripcion:
          'Arrodíllate frente a una máquina de polea con cable con la pierna opuesta al brazo que utilizarás para el ejercicio. Sujeta la cuerda o la barra de la polea con la mano del mismo lado del tríceps que trabajarás, manteniendo el codo fijo. Extiende el brazo hacia abajo, contrayendo el tríceps, y luego flexiona el codo para llevar la barra o la cuerda hacia arriba. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsConCablePoleaPorArribaArrodillado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps con Cuerda y Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con la cuerda o la barra de la polea en tus manos, mantén los codos cerca del cuerpo. Extiende los brazos hacia abajo, contrayendo los tríceps, y luego flexiona los codos para llevar la barra o la cuerda hacia arriba. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsConCuerdaYCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps con Cuerda y Cable-Polea por Arriba (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con la cuerda o la barra de la polea en tus manos, mantén los codos cerca del cuerpo. Extiende los brazos hacia abajo, contrayendo los tríceps, y luego flexiona los codos para llevar la barra o la cuerda hacia arriba. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsConCuerdaYCablePoleaPorArribaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Press de Tríceps con Cuerda y Cable-Polea por Arriba (inclinado)',
      descripcion:
          'Siéntate en un banco inclinado frente a una máquina de polea con cable con la cuerda o la barra de la polea en tus manos, manteniendo los codos cerca del cuerpo. Extiende los brazos hacia abajo, contrayendo los tríceps, y luego flexiona los codos para llevar la barra o la cuerda hacia arriba. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsConCuerdaYCablePoleaPorArribaInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Press de Tríceps con Mancuernas Ambas con Brazos Arriba (sentado)',
      descripcion:
          'Siéntate en un banco con la espalda recta y levanta una mancuerna en cada mano con los brazos extendidos hacia arriba. Mantén los codos cerca de la cabeza y flexiona los codos para bajar las mancuernas hacia los hombros. Luego, extiende los brazos para levantar las mancuernas hacia arriba. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsConMancuernasAmbasConBrazosArribaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps con Mancuernas por Arriba (inclinado)',
      descripcion:
          'Siéntate en un banco inclinado con la espalda recta y levanta una mancuerna en cada mano con los brazos extendidos hacia arriba. Mantén los codos cerca de la cabeza y flexiona los codos para bajar las mancuernas hacia los hombros. Luego, extiende los brazos para levantar las mancuernas hacia arriba. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsConMancuernasPorArribaInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps con Máquina (sentado)',
      descripcion:
          'Siéntate en una máquina de prensa con los pies firmemente apoyados en el suelo y la espalda bien apoyada en el respaldo. Agarra las asas de la máquina con las manos y empuja hacia adelante para extender los brazos, manteniendo los codos ligeramente flexionados. Luego, controladamente, regresa los brazos a la posición inicial flexionando los codos.',
      imagenDireccion:
          Assets.imagenes.musculos.triceps.pressDeTricepsConMaquinaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Press de Tríceps con una Mancuerna con el Brazo Arriba (sentado)',
      descripcion:
          'Siéntate en un banco con la espalda recta y levanta una mancuerna con un brazo extendido hacia arriba. Mantén el codo cerca de la cabeza y flexiona el codo para bajar la mancuerna hacia el hombro. Luego, extiende el brazo para levantar la mancuerna hacia arriba. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressDeTricepsConUnaMancuernaConElBrazoArribaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press de Tríceps en Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con la barra o la cuerda de la polea en tus manos, mantén los codos cerca del cuerpo. Extiende los brazos hacia abajo, contrayendo los tríceps, y luego flexiona los codos para llevar la barra o la cuerda hacia arriba. Controla el movimiento en todo momento.',
      imagenDireccion:
          Assets.imagenes.musculos.triceps.pressDeTricepsEnCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press en Banco Plano con Barra de Pesas, Agarre Cerrado',
      descripcion:
          'Recuéstate en un banco plano con los pies apoyados en el suelo y agarra una barra con las manos separadas a una distancia menor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos hacia arriba, manteniendo los codos cerca del cuerpo. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressEnBancoPlanoConBarraDePesasAgarreCerrado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press en Banco con Barra de Pesas, Agarre Cerrado (declinado)',
      descripcion:
          'Recuéstate en un banco declinado con los pies apoyados en el suelo y agarra una barra con las manos separadas a una distancia menor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos hacia arriba, manteniendo los codos cerca del cuerpo. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressEnBancoConBarraDePesasAgarreCerradoDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Press en Banco con Barra de Pesas, Agarre Cerrado (inclinado)',
      descripcion:
          'Recuéstate en un banco inclinado con los pies apoyados en el suelo y agarra una barra con las manos separadas a una distancia menor que el ancho de los hombros. Levanta la barra hacia arriba y extiende los brazos hacia arriba, manteniendo los codos cerca del cuerpo. Luego, flexiona los codos para bajar la barra hacia abajo, manteniendo los codos fijos. Controla el movimiento en todo momento.',
      imagenDireccion: Assets.imagenes.musculos.triceps
          .pressEnBancoConBarraDePesasAgarreCerradoInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Tracción en Barra Paralelas',
      descripcion:
          'Agarra las barras paralelas y suspende tu cuerpo con los brazos extendidos y el cuerpo vertical. Flexiona los codos para subir el cuerpo hacia arriba, manteniendo los codos cerca del cuerpo. Luego, extiende los brazos para bajar el cuerpo de vuelta a la posición inicial. Controla el movimiento en todo momento.',
      imagenDireccion:
          Assets.imagenes.musculos.triceps.traccionEnBarraParalelas.path,
    ),
  ];

  List<Ejercicio> antebrazo = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Contracción de Mano y Antebrazo con Disco (de pie)',
      descripcion:
          'De pie, sostén un disco con el agarre de los dedos hacia arriba y los dedos separados. Contrae los músculos de la mano y el antebrazo para levantar el disco hacia arriba, manteniendo los brazos extendidos. Luego, baja el disco controladamente y repite el movimiento.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .contraccionDeManoYAntebrazoConDiscoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas, Agarre Estrecho por Encima',
      descripcion:
          'Suspendido de una barra con las manos en un agarre estrecho y las palmas hacia ti, levanta el cuerpo hacia arriba flexionando los codos y manteniendo los brazos pegados al cuerpo. Controla el movimiento al bajar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.antebrazo.dominadasAgarreEstrechoPorEncima.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones Laterales de Antebrazo con Cable-Polea (sentado)',
      descripcion:
          'Siéntate frente a una máquina de polea con cable con un agarre lateral en la barra. Mantén el codo pegado al cuerpo y flexiona el codo para llevar la barra hacia arriba, trabajando los músculos del antebrazo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesLateralesDeAntebrazoConCablePoleaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones con Barra EX en Maquina Scott Agarre Cerrado',
      descripcion:
          'Siéntate en una máquina Scott con el brazo apoyado sobre el cojín. Agarra la barra EZ con un agarre cerrado y levanta la barra hacia arriba contrayendo los músculos del antebrazo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesConBarraExEnMaquinaScottAgarreCerrado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Antebrazo con Barra de Pesas Inversa (de pie)',
      descripcion:
          'De pie, sostén una barra de pesas con el agarre de los dedos hacia abajo y los dedos separados. Contrae los músculos de la mano y el antebrazo para levantar la barra hacia arriba, manteniendo los brazos extendidos. Luego, baja la barra controladamente y repite el movimiento.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesDeAntebrazoConBarraDePesasInversaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Antebrazo con Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con un agarre palmar en la barra, flexiona los codos para levantar la barra hacia arriba, trabajando los músculos del antebrazo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesDeAntebrazoConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Antebrazo con Disco Invertido (de pie)',
      descripcion:
          'De pie, sostén un disco con el agarre de los dedos hacia abajo y los dedos separados. Contrae los músculos de la mano y el antebrazo para levantar el disco hacia arriba, manteniendo los brazos extendidos. Luego, baja el disco controladamente y repite el movimiento.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesDeAntebrazoConDiscoInvertidoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Antebrazo con Cable-Polea Inversa (inclinado)',
      descripcion:
          'Siéntate frente a una máquina de polea con cable con un agarre palmar en la barra, inclinando el torso hacia adelante. Flexiona los codos para levantar la barra hacia arriba, trabajando los músculos del antebrazo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesDeAntebrazoConCablePoleaInversaInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Flexiones de Muñeca y Antebrazo con Barra de Pesas Detrás de la Espalda (de pie)',
      descripcion:
          'De pie, sostén una barra de pesas detrás de la espalda con las palmas hacia arriba y los brazos extendidos. Flexiona las muñecas para levantar la barra hacia arriba, trabajando los músculos del antebrazo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes
          .musculos
          .antebrazo
          .flexionesDeMunecaYAntebrazoConBarraDePesasDetrasDeLaEspaldaDePie
          .path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Muñeca y Antebrazo con Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con un agarre palmar en la barra, flexiona las muñecas para levantar la barra hacia arriba, trabajando los músculos del antebrazo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesDeMunecaYAntebrazoConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Muñeca y Antebrazo con Barra EZ (sentado)',
      descripcion:
          'Siéntate en un banco con la espalda recta y agarra una barra EZ con las palmas hacia arriba y los brazos apoyados sobre los muslos. Flexiona las muñecas para levantar la barra hacia arriba, trabajando los músculos del antebrazo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesDeMunecaYAntebrazoConBarraEzSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Muñeca y Antebrazo con Barra EZ (de pie)',
      descripcion:
          'De pie, sostén una barra EZ con las palmas hacia arriba y los brazos extendidos. Flexiona las muñecas para levantar la barra hacia arriba, trabajando los músculos del antebrazo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesDeMunecaYAntebrazoConBarraEzDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Muñeca y Antebrazo con Barra de pesas (sentado)',
      descripcion:
          'Siéntate en un banco con la espalda recta y agarra una barra de pesas con las palmas hacia arriba y los brazos apoyados sobre los muslos. Flexiona las muñecas para levantar la barra hacia arriba, trabajando los músculos del antebrazo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesDeMunecaYAntebrazoConBarraDePesasSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Muñeca y Antebrazo con Mancuernas (sentado)',
      descripcion:
          'Siéntate en un banco con la espalda recta y agarra una mancuerna en cada mano con las palmas hacia arriba y los brazos apoyados sobre los muslos. Flexiona las muñecas para levantar las mancuernas hacia arriba, trabajando los músculos del antebrazo. Controla el movimiento al bajar las mancuernas de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.antebrazo
          .flexionesDeMunecaYAntebrazoConMancuernasSentado.path,
    ),
  ];

  List<Ejercicio> abdominales = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominal intenso',
      descripcion:
          'Acuéstate boca arriba con las piernas flexionadas y los pies apoyados en el suelo. Coloca las manos detrás de la cabeza y eleva el torso hacia las rodillas contrayendo los músculos abdominales. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.abdomen.abdominalIntenso.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales (declinado)',
      descripcion:
          'Acuéstate en un banco declinado con los pies asegurados. Coloca las manos detrás de la cabeza y eleva el torso hacia las rodillas contrayendo los músculos abdominales. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.abdominalesDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales (declinado)',
      descripcion:
          'Acuéstate en un banco declinado con los pies asegurados. Eleva el torso hacia las rodillas contrayendo los músculos abdominales, realizando un movimiento parcial. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.abdominalesParcialesDeclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parcial laterales (acostado)',
      descripcion:
          'Acuéstate de lado con las piernas flexionadas y los brazos cruzados sobre el pecho. Eleva el torso hacia las piernas contrayendo los músculos abdominales laterales. Luego, baja el torso controladamente de vuelta a la posición inicial y repite el ejercicio en el otro lado.',
      imagenDireccion: Assets
          .imagenes.musculos.abdomen.abdominalesParcialLateralesAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales Laterales con Hyperextension',
      descripcion:
          'Acuéstate de lado con las piernas flexionadas y los brazos cruzados sobre el pecho. Eleva el torso hacia las piernas contrayendo los músculos abdominales laterales y realiza una hiperextensión hacia atrás. Luego, baja el torso controladamente de vuelta a la posición inicial y repite el ejercicio en el otro lado.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .abdominalesParcialesLateralesConHyperextension.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales Sostenidos (acostado)',
      descripcion:
          'Acuéstate boca arriba con las piernas flexionadas y los pies apoyados en el suelo. Eleva el torso hacia las rodillas contrayendo los músculos abdominales y sostén la posición durante unos segundos. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .abdominalesParcialesSostenidosAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales Sostenidos Laterales (acostado)',
      descripcion:
          'Acuéstate de lado con las piernas flexionadas y los brazos cruzados sobre el pecho. Eleva el torso hacia las piernas contrayendo los músculos abdominales laterales y sostén la posición durante unos segundos. Luego, baja el torso controladamente de vuelta a la posición inicial y repite el ejercicio en el otro lado.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .abdominalesParcialesSostenidosLateralesAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales con Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con un agarre palmar en la barra, flexiona el torso hacia adelante contrayendo los músculos abdominales. Luego, regresa el torso a la posición inicial controladamente.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .abdominalesParcialesConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales con Cable-Polea (sentado)',
      descripcion:
          'Siéntate frente a una máquina de polea con cable con un agarre palmar en la barra, flexiona el torso hacia adelante contrayendo los músculos abdominales. Luego, regresa el torso a la posición inicial controladamente.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .abdominalesParcialesConCablePoleaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales de Bicicleta',
      descripcion:
          'Acuéstate boca arriba con las manos detrás de la cabeza y las piernas elevadas. Alterna el movimiento llevando el codo derecho hacia la rodilla izquierda mientras extiendes la pierna derecha hacia adelante. Luego, alterna hacia el otro lado manteniendo el movimiento constante.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.abdominalesParcialesDeBicicleta.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales de Bicicleta Alternando',
      descripcion:
          'Acuéstate boca arriba con las manos detrás de la cabeza y las piernas elevadas. Alterna el movimiento llevando el codo hacia la rodilla opuesta mientras extiendes la pierna contraria hacia adelante. Mantén el movimiento constante y controlado.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .abdominalesParcialesDeBicicletaAlternando.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales de Reversa, Piernas Elevadas',
      descripcion:
          'Acuéstate boca arriba con las manos detrás de la cabeza y las piernas elevadas en un ángulo de 90 grados. Eleva el torso hacia las piernas contrayendo los músculos abdominales. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .abdominalesParcialesDeReversaPiernasElevadas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales, Piernas Elevadas',
      descripcion:
          'Acuéstate boca arriba con las piernas elevadas en un ángulo de 90 grados. Coloca las manos detrás de la cabeza y eleva el torso hacia las rodillas contrayendo los músculos abdominales. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.abdomen.abdominalesParcialesPiernasElevadas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales Parciales, Piernas Flexionadas',
      descripcion:
          'Acuéstate boca arriba con las piernas flexionadas y los pies apoyados en el suelo. Coloca las manos detrás de la cabeza y eleva el torso hacia las rodillas contrayendo los músculos abdominales. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .abdominalesParcialesPiernasFlexionadas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales de Giro, Piernas Elevadas',
      descripcion:
          'Acuéstate boca arriba con las piernas elevadas en un ángulo de 90 grados. Coloca las manos detrás de la cabeza y lleva el codo derecho hacia la rodilla izquierda mientras giras el torso. Luego, alterna hacia el otro lado manteniendo el movimiento constante.',
      imagenDireccion: Assets
          .imagenes.musculos.abdomen.abdominalesDeGiroPiernasElevadas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales de Giro Piernas Flexionadas',
      descripcion:
          'Acuéstate boca arriba con las piernas flexionadas y los pies apoyados en el suelo. Coloca las manos detrás de la cabeza y lleva el codo derecho hacia la rodilla izquierda mientras giras el torso. Luego, alterna hacia el otro lado manteniendo el movimiento constante.',
      imagenDireccion: Assets
          .imagenes.musculos.abdomen.abdominalesDeGiroPiernasFlexionadas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales de pliegue (acostado)',
      descripcion:
          'Acuéstate boca arriba con las piernas flexionadas y los pies apoyados en el suelo. Coloca las manos detrás de la cabeza y eleva el torso hacia las rodillas contrayendo los músculos abdominales. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.abdominalesDePliegueAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales, Piernas Elevadas',
      descripcion:
          'Acuéstate boca arriba con las piernas elevadas en un ángulo de 90 grados. Coloca las manos detrás de la cabeza y eleva el torso hacia las rodillas contrayendo los músculos abdominales. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.abdominalesPiernasElevadas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abdominales, Piernas Flexionadas',
      descripcion:
          'Acuéstate boca arriba con las piernas flexionadas y los pies apoyados en el suelo. Coloca las manos detrás de la cabeza y eleva el torso hacia las rodillas contrayendo los músculos abdominales. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.abdominalesPiernasFlexionadas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Alternar Tocando el Talon (acostado)',
      descripcion:
          'Acuéstate boca arriba con las piernas flexionadas y los pies apoyados en el suelo. Alterna tocando el talón izquierdo con la mano derecha y el talón derecho con la mano izquierda, manteniendo los abdominales contraídos.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.alternarTocandoElTalonAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Ejercicio de Piernas (acostado)',
      descripcion:
          'Acuéstate boca arriba con las piernas flexionadas y los pies apoyados en el suelo. Levanta las piernas hacia el pecho, manteniendo los abdominales contraídos, y luego baja lentamente las piernas de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.ejercicioDePiernasAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Elevación de Rodilla (suspendido)',
      descripcion:
          'Suspendido en una barra, flexiona las rodillas llevando las rodillas hacia el pecho contrayendo los músculos abdominales. Luego, baja las piernas controladamente de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.elevacionDeRodillaSuspendido.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Elevación de Rodilla, Apoyo en los Brazos',
      descripcion:
          'Colócate en posición de plancha con los brazos extendidos y las manos apoyadas en el suelo. Eleva una rodilla hacia el pecho contrayendo los músculos abdominales, mantén la posición por un momento y luego baja la pierna de vuelta a la posición inicial. Alterna el movimiento con la otra pierna.',
      imagenDireccion: Assets
          .imagenes.musculos.abdomen.elevacionDeRodillaApoyoEnLosBrazos.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexión Lateral del Torso con Barra de Pesas (de pie)',
      descripcion:
          'De pie, sostén una barra de pesas sobre los hombros con las manos separadas al ancho de los hombros. Inclina el torso hacia un lado, contrayendo los músculos abdominales laterales, y luego regresa a la posición inicial. Alterna el movimiento hacia el otro lado.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .flexionLateralDelTorsoConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexion Lateral del Torso con Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con un agarre lateral en la barra, inclina el torso hacia un lado contrayendo los músculos abdominales laterales. Luego, regresa el torso a la posición inicial. Alterna el movimiento hacia el otro lado.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .flexionLateralDelTorsoConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexion Lateral del Torso con Mancuernas (de pie)',
      descripcion:
          'De pie, sostén una mancuerna en una mano con el brazo extendido a un lado del cuerpo. Inclina el torso hacia el lado opuesto, contrayendo los músculos abdominales laterales, y luego regresa a la posición inicial. Alterna el movimiento hacia el otro lado.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .flexionLateralDelTorsoConMancuernasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Giro de Torso con Barra de Pesas (de pie)',
      descripcion:
          'De pie, sostén una barra de pesas sobre los hombros con las manos separadas al ancho de los hombros. Gira el torso hacia un lado, contrayendo los músculos abdominales oblicuos, y luego regresa a la posición inicial. Alterna el movimiento hacia el otro lado.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.giroDeTorsoConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Halar con Cable-Polea y Brazo Recto (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con un agarre en una mano, estira el brazo hacia abajo y tira del cable hacia la cadera contrayendo los músculos abdominales. Luego, regresa el brazo a la posición inicial. Repite el ejercicio con el otro brazo.',
      imagenDireccion: Assets
          .imagenes.musculos.abdomen.halarConCablePoleaYBrazoRectoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento de Cadera Lateral (acostado)',
      descripcion:
          'Acuéstate de lado con el codo apoyado en el suelo y las piernas extendidas. Eleva las caderas hacia el techo contrayendo los músculos abdominales laterales, mantén la posición por un momento y luego baja las caderas de vuelta a la posición inicial. Repite el ejercicio en el otro lado.',
      imagenDireccion: Assets
          .imagenes.musculos.abdomen.levantamientoDeCaderaLateralAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento de Pelvis, Piernas Elevadas (acostado)',
      descripcion:
          'Acuéstate boca arriba con las piernas elevadas en un ángulo de 90 grados. Eleva las caderas hacia el techo contrayendo los músculos abdominales, mantén la posición por un momento y luego baja las caderas controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .levantamientoDePelvisPiernasElevadasAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento de Pelvis, Piernas Flexionadas (acostado)',
      descripcion:
          'Acuéstate boca arriba con las piernas flexionadas y los pies apoyados en el suelo. Eleva las caderas hacia el techo contrayendo los músculos abdominales, mantén la posición por un momento y luego baja las caderas controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .levantamientoDePelvisPiernasFlexionadasAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento de Piernas (acostado)',
      descripcion:
          'Acuéstate boca arriba con las piernas extendidas. Eleva las piernas hacia el techo contrayendo los músculos abdominales, mantén la posición por un momento y luego baja las piernas controladamente de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.levantamientoDePiernasAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento de Piernas (suspendido)',
      descripcion:
          'Suspendido en una barra, flexiona las caderas y las rodillas llevando las piernas hacia el pecho contrayendo los músculos abdominales. Luego, baja las piernas controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.abdomen.levantamientoDePiernasSuspendido.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento de Piernas, Apoyo en los Brazos',
      descripcion:
          'Colócate en posición de plancha con los brazos extendidos y las manos apoyadas en el suelo. Eleva las piernas hacia el techo contrayendo los músculos abdominales, mantén la posición por un momento y luego baja las piernas controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .levantamientoDePiernasApoyoEnLosBrazos.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquina de Abdominales Parciales (sentado)',
      descripcion:
          'Siéntate en una máquina de abdominales con los pies asegurados y las manos en las asas. Eleva el torso hacia las rodillas contrayendo los músculos abdominales. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.abdomen.maquinaDeAbdominalesParcialesSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquina de Abdominales Parciales Laterales (sentado)',
      descripcion:
          'Siéntate en una máquina de abdominales con los pies asegurados y las manos en las asas. Eleva el torso hacia un lado contrayendo los músculos abdominales laterales. Luego, baja el torso controladamente de vuelta a la posición inicial y repite el ejercicio en el otro lado.',
      imagenDireccion: Assets.imagenes.musculos.abdomen
          .maquinaDeAbdominalesParcialesLateralesSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Pataleo (acostado)',
      descripcion:
          'Acuéstate boca arriba con las piernas extendidas y los brazos a los lados del cuerpo. Alterna levantando una pierna hacia arriba mientras mantienes la otra pierna cerca del suelo. Realiza un movimiento de pedaleo continuo, contrayendo los músculos abdominales.',
      imagenDireccion: Assets.imagenes.musculos.abdomen.pataleoAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Planks',
      descripcion:
          'Colócate en posición de plancha con los antebrazos y los dedos de los pies apoyados en el suelo, manteniendo el cuerpo en línea recta desde la cabeza hasta los talones. Contrayendo los músculos abdominales, mantén la posición durante el tiempo deseado.',
      imagenDireccion: Assets.imagenes.musculos.abdomen.planks.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Rodamiento de pesas (arrodillado)',
      descripcion:
          'Arrodíllate en el suelo sosteniendo una pesa con ambas manos frente al pecho. Contrae los músculos abdominales y rueda la pesa hacia adelante, extendiendo los brazos mientras mantienes el cuerpo en línea recta. Luego, rueda la pesa de vuelta hacia el cuerpo, flexionando los brazos.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.rodamientoDePesasArrodillado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Tocar los Dedos de los Pies (acostado)',
      descripcion:
          'Acuéstate boca arriba con las piernas extendidas y los brazos extendidos por encima de la cabeza. Eleva el torso hacia las piernas contrayendo los músculos abdominales y trata de tocar los dedos de los pies con las manos. Luego, baja el torso controladamente de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.abdomen.tocarLosDedosDeLosPiesAcostado.path,
    ),
  ];

  List<Ejercicio> espalda = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas con Maquina Sostenida, Agarre Amplio por Debajo',
      descripcion:
          'Con la máquina sostenida y un agarre amplio por debajo, colócate en posición de suspensión. Tira del cuerpo hacia arriba flexionando los codos hasta que la barra esté por debajo del mentón. Luego, baja controladamente hasta estirar completamente los brazos.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .dominadasConMaquinaSostenidaAgarreAmplioPorDebajo.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas en Maquina Sostenida, Agarre Amplio por Encima',
      descripcion:
          'Con la máquina sostenida y un agarre amplio por encima, colócate en posición de suspensión. Tira del cuerpo hacia arriba flexionando los codos hasta que la barra esté por encima del mentón. Baja el cuerpo controladamente hasta estirar completamente los brazos.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .dominadasEnMaquinaSostenidaAgarreAmplioPorEncima.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas en Maquina Sostenida, Agarre Medio por Debajo',
      descripcion:
          'Usando la máquina sostenida y un agarre medio por debajo, cuelga del aparato con los brazos extendidos. Luego, flexiona los codos para llevar el cuerpo hacia arriba hasta que el mentón esté por encima de la barra. Regresa lentamente a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .dominadasEnMaquinaSostenidaAgarreMedioPorDebajo.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas en Maquina Sostenida, Agarre Medio por Encima',
      descripcion:
          'Con la máquina sostenida y un agarre medio por encima, colócate en posición de suspensión. Tira del cuerpo hacia arriba flexionando los codos hasta que la barra esté por encima del mentón. Controla el movimiento al bajar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .dominadasEnMaquinaSostenidaAgarreMedioPorEncima.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas, Agarre Amplio por Debajo',
      descripcion:
          'Agarra la barra de dominadas con un agarre amplio y las palmas hacia afuera. Levanta el cuerpo hacia arriba flexionando los codos hasta que la barbilla esté sobre la barra. Luego, baja el cuerpo de forma controlada hasta la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espalda.dominadasAgarreAmplioPorDebajo.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas, Agarre Amplio por Encima',
      descripcion:
          'Agarra la barra de dominadas con un agarre amplio y las palmas hacia adentro. Levanta el cuerpo hacia arriba flexionando los codos hasta que la barbilla esté sobre la barra. Controla el movimiento al bajar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espalda.dominadasAgarreAmplioPorEncima.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas, Agarre Medio Por Debajo',
      descripcion:
          'Agarra la barra de dominadas con un agarre medio y las palmas hacia afuera. Levanta el cuerpo hacia arriba flexionando los codos hasta que la barbilla esté sobre la barra. Baja el cuerpo controladamente hasta la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espalda.dominadasAgarreMedioPorDebajo.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas, Agarre Medio Por Encima',
      descripcion:
          'Agarra la barra de dominadas con un agarre medio y las palmas hacia adentro. Levanta el cuerpo hacia arriba flexionando los codos hasta que la barbilla esté sobre la barra. Controla el movimiento al bajar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espalda.dominadasAgarreMedioPorEncima.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Espalda a Tórax con Cable-Polea, Agarre Cerrado de Mantillo (sentado)',
      descripcion:
          'Siéntate frente a una máquina de polea con cable con un agarre cerrado de mantillo. Tira de la barra hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al regresar la barra a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .espaldaAToraxConCablePoleaAgarreCerradoDeMantilloSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Espalda a Tórax con Cable-Polea, Agarre Cerrado de Debajo (sentado)',
      descripcion:
          'Siéntate frente a una máquina de polea con cable con un agarre cerrado de debajo. Tira de la barra hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al regresar la barra a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .espaldaAToraxConCablePoleaAgarreCerradoDebajoSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Espalda con Cable-Polea Detrás del Cuello, Agarre Amplio (sentado)',
      descripcion:
          'Siéntate frente a una máquina de polea con cable con un agarre amplio detrás del cuello. Tira de la barra hacia abajo y hacia atrás, manteniendo los codos extendidos. Controla el movimiento al regresar la barra a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .espaldaConCablePoleaDetrasDelCuelloAgarreAmplioSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Espalda con Cable-Polea al Tórax, Agarre Amplio (sentado)',
      descripcion:
          'Siéntate frente a una máquina de polea con cable con un agarre amplio hacia el torso. Tira de la barra hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al regresar la barra a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .espaldaConCablePoleaAlToraxAgarreAmplioSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Espalda con Maquina de Palanca (sentado)',
      descripcion:
          'Siéntate en una máquina de palanca y agarra las manijas con un agarre amplio. Tira de las manijas hacia tu torso manteniendo la espalda recta. Controla el movimiento al regresar las manijas a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.espalda.espaldaConMaquinaDePalancaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo con Barra de Pesas, Inclinado (de pie)',
      descripcion:
          'De pie, inclínate hacia adelante con la espalda recta y agarra la barra de pesas con un agarre amplio. Tira de la barra hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.espalda.remoConBarraDePesasInclinadoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo con Barra de Pesas, Inclinado, Agarre por Abajo (de pie)',
      descripcion:
          'De pie, inclínate hacia adelante con la espalda recta y agarra la barra de pesas con un agarre por abajo. Tira de la barra hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .remoConBarraDePesasInclinadoAgarrePorAbajoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo con Cable-Polea (sentado)',
      descripcion:
          'Siéntate frente a una máquina de polea con cable con un agarre amplio. Tira de la barra hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al regresar la barra a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espalda.remoConCablePoleaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo con Cable-Polea, Inclinado (de pie)',
      descripcion:
          'De pie, agarra la barra de polea inclinado hacia adelante con la espalda recta. Tira de la barra hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al regresar la barra a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espalda.remoConCablePoleaInclinadoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo con Mancuernas, Inclinado (de pie)',
      descripcion:
          'De pie, inclínate hacia adelante con la espalda recta y sostén una mancuerna en cada mano. Tira de las mancuernas hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al bajar las mancuernas de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espalda.remoConMancuernasInclinadoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo con Máquina de Palanca (sentado)',
      descripcion:
          'Siéntate en una máquina de palanca y agarra las manijas con un agarre amplio. Tira de las manijas hacia tu torso manteniendo la espalda recta. Controla el movimiento al regresar las manijas a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espalda.remoConMaquinaDePalancaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo con Máquina de Smith, Inclinado (de pie)',
      descripcion:
          'De pie, inclínate hacia adelante con la espalda recta y agarra la barra de la máquina Smith con un agarre amplio. Tira de la barra hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.espalda.remoConMaquinaDeSmithInclinadoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo en Banco Plano Alto con Barra de Pesas (prono)',
      descripcion:
          'Recuéstate boca abajo en un banco plano alto y agarra la barra de pesas con un agarre amplio. Tira de la barra hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al bajar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .remoEnBancoPlanoAltoConBarraDePesasProno.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo en Banco Plano Alto con Mancuernas (prono)',
      descripcion:
          'Recuéstate boca abajo en un banco plano alto y sostén una mancuerna en cada mano. Tira de las mancuernas hacia tu torso manteniendo los codos cerca del cuerpo. Controla el movimiento al bajar las mancuernas de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espalda
          .remoEnBancoPlanoAltoConMancuernasProno.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Step-up con Barra de Pesas, Inclinado (De pie)',
      descripcion:
          'De pie, coloca una barra de pesas en la parte superior de los hombros. Sube un pie a un banco o plataforma elevada y luego el otro, llevando el cuerpo hacia arriba. Baja controladamente hasta que ambos pies estén en el suelo y repite el movimiento.',
      imagenDireccion: Assets
          .imagenes.musculos.espalda.stepUpConBarraDePesasInclinadoDePie.path,
    ),
  ];

  List<Ejercicio> espaldaBaja = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Arrastre Mediante con Cuerda y Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cuerda, agarra las asas con ambas manos. Mantén la espalda recta y los brazos extendidos. Tira de la cuerda hacia abajo y hacia atrás, llevando los omóplatos juntos. Controla el movimiento al regresar la cuerda a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espaldaBaja
          .arrastreMedianteConCuerdaYPoleaDePie.path,
    ),
    Ejercicio(
        id: DatabaseHelper.instance.generateUUID(),
        nombre: 'Barra de Peso Muerto',
        descripcion:
            'De pie con los pies separados al ancho de los hombros, agarra una barra con las manos separadas al ancho de los hombros. Flexiona las caderas y las rodillas para bajar la barra hacia el suelo, manteniendo la espalda recta. Luego, estira las caderas y las rodillas para levantar la barra de vuelta a la posición inicial.'),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Estiramiento de Gato en Tapete (arrodillado)',
      descripcion:
          'Arrodíllate en el suelo con las manos apoyadas en un tapete. Inclina la pelvis hacia atrás y lleva el pecho hacia el suelo, arqueando la espalda. Mantén la posición durante unos segundos y luego regresa a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espaldaBaja
          .estiramientoDeGatoEnTapeteArrodillado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Espalda con Barra de Pesas (sentado)',
      descripcion:
          'Siéntate en un banco con la espalda recta y agarra una barra de pesas con las manos separadas al ancho de los hombros. Flexiona la parte superior del cuerpo hacia adelante desde la cintura manteniendo la espalda recta. Luego, regresa a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espaldaBaja
          .flexionesDeEspaldaConBarraDePesasSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Espalda con Barra de Pesas (de pie)',
      descripcion:
          'De pie con los pies separados al ancho de los hombros, agarra una barra de pesas con las manos separadas al ancho de los hombros. Flexiona la parte superior del cuerpo hacia adelante desde la cintura manteniendo la espalda recta. Luego, regresa a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espaldaBaja
          .flexionesDeEspaldaConMaquinaSmithDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Espalda con Maquina Smith (de pie)',
      descripcion:
          'De pie frente a una máquina Smith, coloca la barra en la parte superior de los hombros. Flexiona la parte superior del cuerpo hacia adelante desde la cintura manteniendo la espalda recta. Luego, regresa a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espaldaBaja
          .flexionesDeEspaldaConMaquinaSmithDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Espalda con Tapete (prono)',
      descripcion:
          'Recuéstate boca abajo en un tapete con los brazos extendidos hacia adelante. Levanta la parte superior del cuerpo del suelo manteniendo la espalda recta. Luego, baja controladamente de vuelta al suelo.',
      imagenDireccion: Assets
          .imagenes.musculos.espaldaBaja.flexionesDeEspaldaConTapeteProno.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Hiperextensiones en Banco Plano (prono)',
      descripcion:
          'Recuéstate boca abajo en un banco plano con las caderas en el borde y los pies sujetos. Coloca las manos detrás de la cabeza o cruzadas sobre el pecho. Levanta la parte superior del cuerpo hacia arriba manteniendo la espalda recta. Controla el movimiento al bajar de vuelta al banco.',
      imagenDireccion: Assets
          .imagenes.musculos.espaldaBaja.hiperextensionesEnBancoPlanoProno.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquina de Hiperextensiones',
      descripcion:
          'Siéntate en una máquina de hiperextensiones con las piernas debajo de los rodillos y las caderas sobre el soporte acolchado. Flexiona la parte superior del cuerpo hacia adelante desde la cintura y luego regresa a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espaldaBaja.maquinaDeHiperextensiones.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquina de hiperextensiones (sentado)',
      descripcion:
          'Siéntate en una máquina de hiperextensiones con las piernas debajo de los rodillos y las caderas sobre el soporte acolchado. Flexiona la parte superior del cuerpo hacia adelante desde la cintura y luego regresa a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.espaldaBaja.maquinaDeHiperextensionesSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Peso Muerto Sumo con Barra de Pesas, Pies Separadas',
      descripcion:
          'De pie con los pies separados más allá del ancho de los hombros y los dedos de los pies ligeramente hacia afuera, agarra una barra de pesas con las manos separadas al ancho de los hombros. Flexiona las caderas y las rodillas para bajar la barra hacia el suelo, manteniendo la espalda recta. Luego, estira las caderas y las rodillas para levantar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espaldaBaja
          .pesoMuertoSumoConBarraDePesasPiesSeparadas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Peso Muerto con Cable-Polea',
      descripcion:
          'De pie frente a una máquina de polea con cable con una barra o asa. Agarra la barra o asa con ambas manos y lleva las manos hacia arriba delante del cuerpo. Flexiona las caderas y las rodillas para bajar el cuerpo hacia abajo, manteniendo la espalda recta. Luego, estira las caderas y las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espaldaBaja.pesoMuertoConCablePolea.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Peso Muerto con Mancuernas',
      descripcion:
          'De pie con los pies separados al ancho de los hombros, sostén una mancuerna en cada mano con los brazos extendidos hacia abajo. Flexiona las caderas y las rodillas para bajar las mancuernas hacia el suelo, manteniendo la espalda recta. Luego, estira las caderas y las rodillas para levantar las mancuernas de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.espaldaBaja.pesoMuertoConMancuernas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas con Barra de Pesas (arrodillado)',
      descripcion:
          'Arrodíllate en el suelo con una barra de pesas apoyada sobre los hombros. Mantén la espalda recta y los pies separados al ancho de los hombros. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espaldaBaja
          .sentadillasConBarraDePesasArrodillado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas con Barra de Pesas (de pie)',
      descripcion:
          'De pie con la barra de pesas apoyada sobre los hombros y los pies separados al ancho de los hombros. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.espaldaBaja.sentadillasConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas con Barra de Pesas Frontal (de pie)',
      descripcion:
          'De pie con la barra de pesas apoyada sobre los hombros y los codos levantados hacia adelante, mantén los pies separados al ancho de los hombros. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espaldaBaja
          .sentadillasConBarraDePesasFrontalDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas en Maquina de Palanca (de pie)',
      descripcion:
          'De pie frente a una máquina de palanca con los hombros debajo de las almohadillas. Flexiona las rodillas para bajar el cuerpo hacia abajo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.espaldaBaja
          .sentadillasEnMaquinaDePalancaDePie.path,
    ),
  ];

  List<Ejercicio> gluteos = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Arrastre Mediante con Cuerda y Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cuerda, agarra las asas con ambas manos. Mantén la espalda recta y los brazos extendidos. Tira de la cuerda hacia abajo y hacia atrás, llevando los omóplatos juntos. Controla el movimiento al regresar la cuerda a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.arrastreMedianteConCuerdaYPoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Barra de Peso Muerto',
      descripcion:
          'De pie con los pies separados al ancho de los hombros, agarra una barra con las manos separadas al ancho de los hombros. Flexiona las caderas y las rodillas para bajar la barra hacia el suelo, manteniendo la espalda recta. Luego, estira las caderas y las rodillas para levantar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.gluteo.barraDePesoMuerto.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Estocadas en Barra de Pesas',
      descripcion:
          'De pie con los pies separados al ancho de los hombros, sostén una barra de pesas en los hombros. Da un paso hacia adelante con una pierna y flexiona ambas rodillas para bajar el cuerpo hacia el suelo. Luego, impúlsate con la pierna delantera para volver a la posición inicial y repite con la otra pierna.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.estocadasEnBarraDePesas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Estocadas en Mancuernas',
      descripcion:
          'De pie con los pies separados al ancho de los hombros, sostén una mancuerna en cada mano a los lados del cuerpo. Da un paso hacia adelante con una pierna y flexiona ambas rodillas para bajar el cuerpo hacia el suelo. Luego, impúlsate con la pierna delantera para volver a la posición inicial y repite con la otra pierna.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.estocadasEnMancuernas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Extensión de Cadera en Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con un tobillo sujeto a la correa de la polea baja. Levanta la pierna hacia atrás mientras mantienes la pierna recta, contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al bajar la pierna de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.extensionDeCaderaEnCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Extensión de Pierna hacia atrás (arrodillado)',
      descripcion:
          'Arrodíllate en el suelo con las manos apoyadas en el suelo y una pierna extendida hacia atrás. Levanta la pierna hacia el techo, contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al bajar la pierna de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.extensionDePiernaHaciaAtrasArrodillado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Extension de la Cadera (arrodillado)',
      descripcion:
          'Arrodíllate en el suelo con las manos apoyadas en el suelo y una pierna extendida hacia atrás. Levanta la pierna hacia el techo, contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al bajar la pierna de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.extensionDeLaCaderaArrodillado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Extension de la Cadera con maquina',
      descripcion:
          'Arrodíllate en una máquina de extensión de cadera con las manos apoyadas en los mangos y una pierna extendida hacia atrás. Levanta la pierna hacia el techo, contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al bajar la pierna de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.extensionDeLaCaderaConMaquina.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexion de Espalda con Barra de Pesas (de pie)',
      descripcion:
          'De pie con la barra de pesas apoyada sobre los hombros, flexiona las caderas hacia adelante mientras mantienes la espalda recta. Luego, estira las caderas para volver a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.flexionDeEspaldaConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexión de Espalda con Maquina Smith (de pie)',
      descripcion:
          'De pie frente a una máquina Smith, coloca la barra en la parte superior de los hombros. Flexiona las caderas hacia adelante mientras mantienes la espalda recta. Luego, estira las caderas para volver a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.flexionDeEspaldaConMaquinaSmithDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Levantamiento de Pelvis, Piernas Flexionadas (acostado)',
      descripcion:
          'Acuéstate boca arriba con las rodillas dobladas y los pies apoyados en el suelo. Levanta las caderas hacia el techo contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al bajar las caderas de vuelta al suelo.',
      imagenDireccion: Assets.imagenes.musculos.gluteo
          .levantamientoDePelvisPiernasFlexionadasAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquina de Abducción (sentado)',
      descripcion:
          'Siéntate en una máquina de abducción con las piernas apoyadas sobre los rodillos y los muslos sujetos. Separa las piernas hacia afuera, contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al juntar las piernas de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.maquinaDeAbduccionSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquinas de Aducción (sentado)',
      descripcion:
          'Siéntate en una máquina de aducción con las piernas apoyadas sobre los rodillos y los muslos sujetos. Junta las piernas hacia adentro, contrayendo los músculos internos de los muslos en la parte superior del movimiento. Controla el movimiento al separar las piernas de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.maquinaDeAbduccionSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquina de Prensa de Piernas (inclinado)',
      descripcion:
          'Siéntate en una máquina de prensa de piernas con la espalda apoyada en el respaldo. Empuja la plataforma hacia adelante con los pies, extendiendo las rodillas y contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al flexionar las rodillas para bajar la plataforma de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.maquinaDePrensaDePiernasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Maquina de Prensa de Piernas, pies Sentado (inclinado)',
      descripcion:
          'Siéntate en una máquina de prensa de piernas con la espalda apoyada en el respaldo y los pies apoyados en la plataforma. Empuja la plataforma hacia adelante con los pies, extendiendo las rodillas y contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al flexionar las rodillas para bajar la plataforma de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.gluteo
          .maquinaDePrensaDePiernasPiesSentadoInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Pataleo (acostado)',
      descripcion:
          'Acuéstate de lado con la cabeza apoyada en el brazo y la otra mano en el suelo frente a ti para mantener el equilibrio. Levanta la pierna superior hacia el techo, contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al bajar la pierna de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.gluteo.pataleoAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Peso Muerto Sumo con Barra de Pesas, Pies Separados',
      descripcion:
          'De pie con los pies más anchos que el ancho de los hombros y los dedos de los pies ligeramente hacia afuera, agarra una barra de pesas con las manos dentro de los pies. Flexiona las caderas y las rodillas para bajar la barra hacia el suelo, manteniendo la espalda recta. Luego, estira las caderas y las rodillas para levantar la barra de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.gluteo
          .pesoMuertoSumoConBarraDePesasPiesSeparados.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Peso Muerto con Cable-Polea',
      descripcion:
          'De pie frente a una máquina de polea con cable con una correa alrededor de los tobillos. Mantén la espalda recta y las manos en las caderas. Levanta la pierna hacia atrás mientras mantienes la pierna recta, contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al bajar la pierna de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.pesoMuertoConCablePolea.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Peso Muerto con Mancuernas',
      descripcion:
          'De pie con los pies separados al ancho de los hombros, sostén una mancuerna en cada mano frente a los muslos. Flexiona las caderas y las rodillas para bajar las mancuernas hacia el suelo, manteniendo la espalda recta. Luego, estira las caderas y las rodillas para levantar las mancuernas de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.pesoMuertoConMancuernas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas Frontal con Maquina de Smith (de pie)',
      descripcion:
          'De pie con la barra de la máquina Smith en la parte superior de los hombros y los pies separados al ancho de los hombros. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.gluteo
          .sentadillasFrontalConMaquinaDeSmithDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas Hack con Barra de Pesas (de pie)',
      descripcion:
          'De pie con los pies separados al ancho de los hombros, sostén una barra de pesas detrás de las piernas con las manos en la parte baja de la barra. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.sentadillasHackConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas Hack con Maquina de Smith (de pie)',
      descripcion:
          'De pie con la barra de la máquina Smith en la parte superior de los hombros y los pies separados al ancho de los hombros. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.sentadillasHackConMaquinaDeSmithDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas con Barra de Pesas (arrodillado)',
      descripcion:
          'Arrodíllate en el suelo con una barra de pesas apoyada sobre los hombros y los pies apoyados en el suelo. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.sentadillasConBarraDePesasArrodillado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas con Barra de Pesas (de pie)',
      descripcion:
          'De pie con la barra de pesas apoyada sobre los hombros y los pies separados al ancho de los hombros. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.sentadillasConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas con Barra de Pesas Frontal (de pie)',
      descripcion:
          'De pie con la barra de pesas apoyada sobre los hombros y los codos levantados hacia adelante, mantén los pies separados al ancho de los hombros. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.sentadillasConBarraDePesasFrontalDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas con Maquina (inclinado)',
      descripcion:
          'Siéntate en una máquina de sentadillas inclinada con la espalda apoyada en el respaldo y los pies en la plataforma. Empuja la plataforma hacia arriba con los pies, extendiendo las rodillas y contrayendo los glúteos en la parte superior del movimiento. Controla el movimiento al flexionar las rodillas para bajar la plataforma de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.gluteo.sentadillasConMaquinaInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Sentadillas con Maquina de Palanca (de pie)',
      descripcion:
          'De pie con la barra de la máquina de palanca en la parte superior de los hombros y los pies separados al ancho de los hombros. Flexiona las rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, estira las rodillas para levantar el cuerpo de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.gluteo.sentadillasConMaquinaDePalancaDePie.path,
    ),
    //este se repite en cuadriceps
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Skipping Rápido (de pie)',
      descripcion:
          'De pie con los pies separados al ancho de los hombros, alterna levantar las rodillas hacia el pecho a un ritmo rápido. Mantén el torso erguido y los abdominales contraídos durante el ejercicio.',
      imagenDireccion:
          Assets.imagenes.musculos.cuadriceps.skippingRapidoDePie.path,
    ),
  ];

  List<Ejercicio> cuadriceps = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Abductor con Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con una correa alrededor del tobillo. Levanta la pierna hacia afuera, manteniendo la pierna recta, contrayendo los músculos del abductor en la parte superior del movimiento. Controla el movimiento al bajar la pierna de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.cuadriceps.abductorConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Aductor con Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con una correa alrededor del tobillo. Levanta la pierna hacia adentro, manteniendo la pierna recta, contrayendo los músculos del aductor en la parte superior del movimiento. Controla el movimiento al bajar la pierna de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.cuadriceps.aductorConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Barra de peso Muerto',
      descripcion:
          'De pie con los pies separados al ancho de los hombros y la barra de pesas apoyada sobre los muslos. Flexiona las caderas y las rodillas para bajar la barra hacia el suelo, manteniendo la espalda recta. Luego, estira las caderas y las rodillas para levantar la barra de vuelta a la posición inicial.',
      imagenDireccion:
          Assets.imagenes.musculos.cuadriceps.barraDePesoMuerto.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Elevación Lateral de Piernas (acostado)',
      descripcion:
          'Acuéstate de lado con la cabeza apoyada en el brazo y la otra mano en el suelo frente a ti para mantener el equilibrio. Levanta la pierna superior hacia arriba, manteniendo la pierna recta, contrayendo los músculos del cuádriceps en la parte superior del movimiento. Controla el movimiento al bajar la pierna de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.cuadriceps.elevacionLateralDePiernasAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Estocadas con Barra de Pesas',
      descripcion:
          'De pie con la barra de pesas apoyada sobre los hombros y los pies separados al ancho de los hombros. Da un paso hacia adelante con una pierna y flexiona ambas rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, empuja con la pierna delantera para volver a la posición inicial y repite con la otra pierna.',
      imagenDireccion:
          Assets.imagenes.musculos.cuadriceps.estocadasConBarraDePesas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Estocadas con Mancuernas',
      descripcion:
          'De pie con una mancuerna en cada mano a los lados del cuerpo y los pies separados al ancho de los hombros. Da un paso hacia adelante con una pierna y flexiona ambas rodillas para bajar el cuerpo hacia el suelo, manteniendo la espalda recta. Luego, empuja con la pierna delantera para volver a la posición inicial y repite con la otra pierna.',
      imagenDireccion:
          Assets.imagenes.musculos.cuadriceps.estocadasConMancuernas.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Extensión de Piernas con Maquina (sentado)',
      descripcion:
          'Siéntate en una máquina de extensión de piernas con la espalda apoyada en el respaldo y los pies debajo de los rodillos acolchados. Extiende las rodillas para levantar los pesos, contrayendo los músculos del cuádriceps en la parte superior del movimiento. Controla el movimiento al bajar los pesos de vuelta a la posición inicial.',
      imagenDireccion: Assets.imagenes.musculos.cuadriceps
          .extensionDePiernasConMaquinaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Step-up con Barra de Pesas (de pie)',
      descripcion:
          'De pie frente a un banco o plataforma con una barra de pesas sobre los hombros. Coloca un pie en el banco y empuja con ese pie para levantar el cuerpo hacia arriba, extendiendo la cadera y la rodilla. Controla el movimiento al bajar el cuerpo de vuelta al suelo y repite con la otra pierna.',
      imagenDireccion:
          Assets.imagenes.musculos.cuadriceps.stepUpConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Step-up con Mancuernas (de pie)',
      descripcion:
          'De pie frente a un banco o plataforma con una mancuerna en cada mano a los lados del cuerpo. Coloca un pie en el banco y empuja con ese pie para levantar el cuerpo hacia arriba, extendiendo la cadera y la rodilla. Controla el movimiento al bajar el cuerpo de vuelta al suelo y repite con la otra pierna.',
      imagenDireccion:
          Assets.imagenes.musculos.cuadriceps.stepUpConMancuernasDePie.path,
    ),
  ];

  List<Ejercicio> femorales = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Pierna con Maquina (de pie)',
      descripcion:
          'De pie frente a una máquina de flexión de piernas con la parte posterior de las piernas apoyadas sobre los cojines acolchados y las manos sujetando las asas laterales para estabilidad. Flexiona las rodillas para levantar los pesos, contrayendo los músculos de los femorales en la parte posterior del muslo. Controla el movimiento al bajar los pesos de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.femorales.flexionesDePiernaConMaquinaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Pierna con Maquina (prono)',
      descripcion:
          'Acuéstate boca abajo en una máquina de flexión de piernas con la parte posterior de las piernas apoyadas sobre los cojines acolchados y las manos sujetando las asas laterales para estabilidad. Flexiona las rodillas para levantar los pesos, contrayendo los músculos de los femorales en la parte posterior del muslo. Controla el movimiento al bajar los pesos de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.femorales.flexionesDePiernaConMaquinaProno.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Pierna con Maquina (sentado)',
      descripcion:
          'Siéntate en una máquina de flexión de piernas con la espalda apoyada en el respaldo y las piernas debajo de los cojines acolchados. Flexiona las rodillas para levantar los pesos, contrayendo los músculos de los femorales en la parte posterior del muslo. Controla el movimiento al bajar los pesos de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.femorales.flexionesDePiernaConMaquinaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Pierna con Cable-Polea (de pie)',
      descripcion:
          'De pie frente a una máquina de polea con cable con un accesorio en el tobillo y el cable en la parte inferior de la pierna. Flexiona la rodilla para levantar el peso hacia arriba, contrayendo los músculos de los femorales en la parte posterior del muslo. Controla el movimiento al bajar el peso de vuelta a la posición inicial.',
      imagenDireccion: Assets
          .imagenes.musculos.femorales.flexionesDePiernaConCablePoleaDePie.path,
    ),
  ];

  List<Ejercicio> pantorrilla = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Balanceo de Pierna con Barra de Pesas (de pie)',
      descripcion:
          'De pie con una barra de pesas sobre los hombros, levanta los talones del suelo para elevar los talones hacia arriba mientras mantienes las piernas extendidas. Luego, baja los talones controladamente hacia abajo y repite el movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pantorrilla
          .balanceoDePiernaConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Balanceo de Pierna con Barra de Pesas (sentado)',
      descripcion:
          'Sentado en un banco con una barra de pesas sobre los muslos, levanta los talones del suelo para elevar los talones hacia arriba mientras mantienes las piernas extendidas. Luego, baja los talones controladamente hacia abajo y repite el movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pantorrilla
          .balanceoDePiernaConBarraDePesasSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Balanceo de Pantorrilla con Maquina (de pie)',
      descripcion:
          'De pie frente a una máquina de pantorrilla con los hombros debajo de los cojines acolchados y los pies en el borde inferior del aparato, levanta los talones del suelo para elevar los talones hacia arriba. Luego, baja los talones controladamente hacia abajo y repite el movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pantorrilla
          .balanceoDePantorrillaConMaquinaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Balanceo de Pantorrillas con Maquina Smith (sentado)',
      descripcion:
          'Sentado en un banco con los pies debajo de la barra de la máquina Smith, levanta los talones del suelo para elevar los talones hacia arriba. Luego, baja los talones controladamente hacia abajo y repite el movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pantorrilla
          .balanceoDePantorrillasConMaquinaSmithSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Balanceo de Pantorrillas con Maquina Smith (de pie)',
      descripcion:
          'De pie con los pies debajo de la barra de la máquina Smith, levanta los talones del suelo para elevar los talones hacia arriba. Luego, baja los talones controladamente hacia abajo y repite el movimiento.',
      imagenDireccion: Assets.imagenes.musculos.pantorrilla
          .balanceoDePantorrillasConMaquinaSmithDePie.path,
    ),
  ];

  List<Ejercicio> biceps = [
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas en Maquina Sostenida, Agarre Medio por Debajo',
      descripcion:
          'Ejercicio de dominadas utilizando una máquina sostenida con un agarre medio por debajo, enfocando el trabajo en los bíceps y la parte superior de la espalda.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .dominadasEnMaquinaSostenidaAgarreMedioPorDebajo.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas en Maquina Sostenida, Agarre Medio por Encima',
      descripcion:
          'Ejercicio de dominadas utilizando una máquina sostenida con un agarre medio por encima, activando principalmente los bíceps y la parte superior de la espalda.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .dominadasEnMaquinaSostenidaAgarreMedioPorEncima.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas, Agarre Cerrado por Debajo',
      descripcion:
          'Ejercicio de dominadas con un agarre cerrado por debajo, enfocando el esfuerzo en los bíceps y los músculos de la espalda.',
      imagenDireccion:
          Assets.imagenes.musculos.biceps.dominadasAgarreCerradoPorDebajo.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas, Agarre Estrecho por Encima',
      descripcion:
          'Ejercicio de dominadas con un agarre estrecho por encima, trabajando principalmente los bíceps y los músculos de la espalda.',
      imagenDireccion:
          Assets.imagenes.musculos.biceps.dominadasAgarreEstrechoPorEncima.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas, Agarre Medio Por Debajo',
      descripcion:
          'Ejercicio de dominadas con un agarre medio por debajo, activando los bíceps y la parte superior de la espalda.',
      imagenDireccion:
          Assets.imagenes.musculos.biceps.dominadasAgarreMedioPorDebajo.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Dominadas, Agarre Medio Por Encima',
      descripcion:
          'Ejercicio de dominadas con un agarre medio por encima, enfocando el trabajo en los bíceps y la parte superior de la espalda.',
      imagenDireccion:
          Assets.imagenes.musculos.biceps.dominadasAgarreMedioPorEncima.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Espalda a Tórax con Cable-Polea, Agarre Cerrado de Mantillo (sentado)',
      descripcion:
          'Ejercicio de espalda a tórax utilizando una máquina de cable-polea con un agarre cerrado de mantillo, trabajando los bíceps y los músculos de la espalda.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .espaldaAToraxConCablePoleaAgarreCerradoDeMantilloSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Espalda a Tórax con Cable-Polea, Agarre Cerrado de Debajo (de pie)',
      descripcion:
          'Ejercicio de espalda a tórax utilizando una máquina de cable-polea con un agarre cerrado de debajo, activando los bíceps y los músculos de la espalda.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .espaldaAToraxConCablePoleaAgarreCerradoDebajoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps Alternando las Mancuernas (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps alternando las mancuernas de pie, trabajando cada brazo individualmente para mayor concentración y equilibrio muscular.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsAlternandoLasMancuernasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps Alternando las Mancuernas (sentado)',
      descripcion:
          'Ejercicio de flexiones de bíceps alternando las mancuernas sentado, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsAlternandoLasMancuernasSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Flexiones de Biceps Alternando las Mancuernas en Martillo (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps alternando las mancuernas en martillo de pie, enfocando el trabajo en los músculos del brazo y del antebrazo.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsAlternandoLasMancuernasEnMartilloDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Flexiones de Biceps Alternando las Mancuernas en Martillo (sentado)',
      descripcion:
          'Ejercicio de flexiones de bíceps alternando las mancuernas en martillo sentado, permitiendo un mayor control y enfoque en los músculos del brazo y del antebrazo.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsAlternandoLasMancuernasEnMartilloSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Flexiones de Biceps Alternando Concentradas con Cable-Polea (sentado)',
      descripcion:
          'Ejercicio de flexiones de bíceps alternando concentradas con cable-polea sentado, trabajando cada bíceps individualmente con enfoque en la contracción máxima.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsAlternandoConcentradasConCablePoleaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Flexiones de Biceps Alternando Concentradas con Mancuernas (sentado)',
      descripcion:
          'Ejercicio de flexiones de bíceps alternando concentradas con mancuernas sentado, permitiendo un mayor aislamiento y enfoque en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsAlternandoConcentradasConMancuernasSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps Alternando Cruzadas con Mancuernas (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps alternando cruzadas con mancuernas de pie, trabajando cada brazo individualmente para mayor concentración y equilibrio muscular.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsAlternandoCruzadasConMancuernasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre:
          'Flexiones de Biceps Alternando Cruzadas con Mancuernas con Martillo (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps alternando cruzadas con mancuernas en martillo de pie, enfocando el trabajo en los músculos del brazo y del antebrazo.',
      imagenDireccion: Assets
          .imagenes
          .musculos
          .biceps
          .flexionesDeBicepsAlternandoCruzadasConMancuernasConMartilloDePie
          .path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Barra EZ (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una barra EZ de pie, enfocando el trabajo en los bíceps y permitiendo una mejor ergonomía en las muñecas.',
      imagenDireccion:
          Assets.imagenes.musculos.biceps.flexionesDeBicepsConBarraEzDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Barra EZ en Maquina Scott (sentado)',
      descripcion:
          'Ejercicio de flexiones de bíceps con barra EZ en máquina Scott sentado, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConBarraEzEnMaquinaScottSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Barra EZ, Agarre Amplio (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una barra EZ con agarre amplio de pie, enfocando el trabajo en los bíceps y permitiendo una mejor ergonomía en las muñecas.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConBarraEzAgarreAmplioDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Barra EZ, Agarre Cerrado (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una barra EZ con agarre cerrado de pie, enfocando el trabajo en los bíceps y permitiendo una mejor ergonomía en las muñecas.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConBarraEzAgarreCerradoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Barra de Pesas (inclinado)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una barra de pesas en un banco inclinado, permitiendo un mayor rango de movimiento y enfoque en los bíceps.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConBarraDePesasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Barra de Pesas, Agarre Amplio (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una barra de pesas con agarre amplio de pie, enfocando el trabajo en los bíceps y permitiendo un mayor rango de movimiento.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConBarraDePesasAgarreAmplioDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Barra de Pesas, Agarre Cerrado (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una barra de pesas con agarre cerrado de pie, enfocando el trabajo en los bíceps y permitiendo un mayor rango de movimiento.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConBarraDePesasAgarreCerradoDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Barra (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una barra de pie, permitiendo un mayor rango de movimiento y enfoque en los bíceps.',
      imagenDireccion:
          Assets.imagenes.musculos.biceps.flexionesDeBicepsConBarraDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Cable abajo en la Maquina de Scott',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una máquina de Scott con cable abajo, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConCableAbajoEnLaMaquinaDeScott.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Cable-Polea (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una máquina de cable-polea de pie, permitiendo un mayor control y variabilidad en el entrenamiento de bíceps.',
      imagenDireccion: Assets
          .imagenes.musculos.biceps.flexionesDeBicepsConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Cable-Polea por Arriba (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una máquina de cable-polea por arriba de pie, permitiendo un mayor control y variabilidad en el entrenamiento de bíceps.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConCablePoleaPorArribaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Cuerda en Cable-Polea (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una cuerda en máquina de cable-polea de pie, permitiendo un mayor rango de movimiento y enfoque en los bíceps.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConCuerdaEnCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Mancuernas (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando mancuernas de pie, permitiendo un mayor rango de movimiento y enfoque en los bíceps.',
      imagenDireccion: Assets
          .imagenes.musculos.biceps.flexionesDeBicepsConMancuernasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Mancuernas (inclinado)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando mancuernas en un banco inclinado, permitiendo un mayor rango de movimiento y enfoque en los bíceps.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConMancuernasInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Mancuernas (sentado)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando mancuernas sentado, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets
          .imagenes.musculos.biceps.flexionesDeBicepsConMancuernasSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Mancuernas en Martillo (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando mancuernas en martillo de pie, enfocando el trabajo en los músculos del brazo y del antebrazo.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConMancuernasEnMartilloDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Mancuernas en Martillo (sentado)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando mancuernas en martillo sentado, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConMancuernasEnMartilloSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Mancuernas en Martillo en Maquina Scott',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando mancuernas en martillo en máquina Scott, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConMancuernasEnMartilloEnMaquinaScott.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps con Mancuernas en Maquina Scott',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando mancuernas en máquina Scott, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsConMancuernasEnMaquinaScott.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps de Zottman en Mancuernas (de pie)',
      descripcion:
          'Ejercicio de flexiones de bíceps de Zottman utilizando mancuernas de pie, trabajando tanto los bíceps como los antebrazos en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsDeZottmanEnMancuernasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps en Cable-Polea (acostado)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una máquina de cable-polea acostado, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets
          .imagenes.musculos.biceps.flexionesDeBicepsEnCablePoleaAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps en Maquina (sentado)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una máquina sentado, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets
          .imagenes.musculos.biceps.flexionesDeBicepsEnMaquinaSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps en Maquina Scott (sentado)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una máquina Scott sentado, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets
          .imagenes.musculos.biceps.flexionesDeBicepsEnMaquinaScottSentado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps en un Banco Alto con Barra de Pesas (prono)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una barra de pesas en un banco alto prono, permitiendo un mayor rango de movimiento y enfoque en los bíceps.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsEnUnBancoAltoConBarraDePesasProno.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps en un Banco Alto con Mancuernas (prono)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando mancuernas en un banco alto prono, permitiendo un mayor rango de movimiento y enfoque en los bíceps.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsEnUnBancoAltoConMancuernasProno.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps en un Banco en la Cable-Polea (acostado)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una máquina de cable-polea acostado en un banco, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsEnUnBancoEnLaCablePoleaAcostado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps en un Banco en la Cable-Polea (inclinado)',
      descripcion:
          'Ejercicio de flexiones de bíceps utilizando una máquina de cable-polea inclinado en un banco, permitiendo un mayor aislamiento y control en cada repetición.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsEnUnBancoEnLaCablePoleaInclinado.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Flexiones de Biceps y Antebrazo con uno solo Mancuerna',
      descripcion:
          'Ejercicio de flexiones de bíceps y antebrazo utilizando una sola mancuerna, permitiendo un enfoque específico en los músculos del brazo y del antebrazo.',
      imagenDireccion: Assets.imagenes.musculos.biceps
          .flexionesDeBicepsYAntebrazoConUnoSoloMancuerna.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo Vertical con Barra de Pesas (de pie)',
      descripcion:
          'Ejercicio de remo vertical utilizando una barra de pesas de pie, trabajando los músculos de los hombros y los bíceps.',
      imagenDireccion:
          Assets.imagenes.musculos.biceps.remoVerticalConBarraDePesasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo Vertical con Cable-Polea (de pie)',
      descripcion:
          'Ejercicio de remo vertical utilizando una máquina de cable-polea de pie, trabajando los músculos de los hombros y los bíceps.',
      imagenDireccion:
          Assets.imagenes.musculos.biceps.remoVerticalConCablePoleaDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo Vertical con Mancuernas (de pie)',
      descripcion:
          'Ejercicio de remo vertical utilizando mancuernas de pie, trabajando los músculos de los hombros y los bíceps.',
      imagenDireccion:
          Assets.imagenes.musculos.biceps.remoVerticalConMancuernasDePie.path,
    ),
    Ejercicio(
      id: DatabaseHelper.instance.generateUUID(),
      nombre: 'Remo Vertical con Maquina de Smith (de pie)',
      descripcion:
          'Ejercicio de remo vertical utilizando una máquina de Smith de pie, trabajando los músculos de los hombros y los bíceps.',
      imagenDireccion: Assets
          .imagenes.musculos.biceps.remoVerticalConMaquinaDeSmithDePie.path,
    ),
  ];

  Future<void> seedGenerateEjercicios() async {
    try {
      await _insertarEjercicio(trapecio, ['trapecio']);
      await _insertarEjercicio(ejerciciosHombro, ['hombro']);
      await _insertarEjercicio(ejerciciosPecho, ['pecho']);
      await _insertarEjercicio(ejerciciosTriceps, ['triceps']);
      await _insertarEjercicio(antebrazo, ['antebrazo']);
      await _insertarEjercicio(abdominales, ['abdomen']);
      await _insertarEjercicio(espalda, ['espalda']);
      await _insertarEjercicio(espaldaBaja, ['espalda baja']);
      await _insertarEjercicio(gluteos, ['gluteo']);
      await _insertarEjercicio(cuadriceps, ['cuadriceps']);
      await _insertarEjercicio(femorales, ['femorales']);
      await _insertarEjercicio(pantorrilla, ['pantorrilla']);
      await _insertarEjercicio(biceps, ['biceps']);
    } catch (e) {
      logger.e('Error al almacenar los músculos en la base de datos: $e');
      // throw Exception('Error al almacenar los músculos en la base de datos');
    }
  }

  Future<int> _insertarEjercicio(
    List<Ejercicio> ejercicios,
    List<String>? listaNombresMusculos,
  ) async {
    final db = await DatabaseHelper.instance.database;
    int res = 0;

    for (final ejercicio in ejercicios) {
      // Convertir a minúsculas antes de guardar
      ejercicio.nombre = ejercicio.nombre.toLowerCase();
      ejercicio.descripcion = ejercicio.descripcion?.toLowerCase();
      ejercicio.imagenDireccion = ejercicio.imagenDireccion?.toLowerCase();

      // Verificar si el ejercicio ya existe
      final existingEjercicio = await db.query(
        DatabaseHelper.tableEjercicio,
        where: 'nombre = ?',
        whereArgs: [ejercicio.nombre],
      );

      if (existingEjercicio.isEmpty) {
        // Agregamos el ejercicio si no existe
        res +=
            await db.insert(DatabaseHelper.tableEjercicio, ejercicio.toJson());
      } else {
        // Si el ejercicio ya existe, actualizamos su ID
        ejercicio.id = existingEjercicio.first['id'] as String;
      }

      if (listaNombresMusculos == null) continue;

      String idMusculo;
      // Buscamos el músculo
      for (final nombreMusculo in listaNombresMusculos) {
        final musculo = await buscarMusculoPorNombre(nombreMusculo);
        if (musculo == null) {
          // Si no existe el músculo lo agregamos
          final nuevoMusculo = Musculo(
            id: DatabaseHelper.instance.generateUUID(),
            nombre: nombreMusculo,
          );
          await insertarMusculo(nuevoMusculo);
          idMusculo = nuevoMusculo.id;
        } else {
          idMusculo = musculo.id;
        }

        // Insertar la relación en la tabla EjercicioMusculo
        await insertarEjercicioMusculo(
          ejercicioId: ejercicio.id,
          musculoId: idMusculo,
        );
      }
    }
    return res;
  }

  //funcion que almacena las relaciones entre ejercicios y musculo
  Future<bool> insertarEjercicioMusculo({
    required String ejercicioId,
    required String musculoId,
  }) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final ejercicioMusculo = EjercicioMusculo(
        ejercicioId: ejercicioId,
        musculoId: musculoId,
      );
      final result = await db.insert(
        DatabaseHelper.tableEjercicioMusculo,
        ejercicioMusculo.toJson(),
      );
      return result != -1;
    } catch (e) {
      logger.e('Error al insertar la relación Ejercicio-Musculo: $e');
      return false;
    }
  }

  Future<Musculo?> buscarMusculoPorNombre(String nombreMusculo) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final res = await db.query(
        DatabaseHelper.tableMusculo,
        where: 'nombre = ?',
        whereArgs: [nombreMusculo],
      );
      if (res.isNotEmpty) {
        return Musculo.fromJson(res.first);
      }

      return null;
    } catch (e) {
      logger.e('Error al buscar el músculo: $e');
      return null;
    }
  }

// Insertar el músculo
  Future<String?> insertarMusculo(Musculo musculo) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert(DatabaseHelper.tableMusculo, musculo.toJson());
      return musculo.id;
    } catch (e) {
      print('Error al insertar el músculo: $e');
      return null;
    }
  }
}

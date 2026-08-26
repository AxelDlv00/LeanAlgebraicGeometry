/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib.AlgebraicGeometry.Gluing

/-!
# Explicit maps out of a scheme gluing

`Scheme.GlueData` exposes the glued scheme, but applications commonly rebuild the
same chart maps and their compatibility proof every time they need the structure
map.  `GluedMapData` keeps those maps together.  It is intentionally a data record,
so changing a local algebra witness does not change the public shape of a consumer's
theorem.  No typeclass instances are installed by this API.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open AlgebraicGeometry

namespace AlgebraicJacobian

noncomputable section

/-- A morphism from a scheme gluing, together with its chart restrictions. -/
structure GluedMapData (D : Scheme.GlueData.{u}) (Y : Scheme.{u}) where
  map : D.glued ⟶ Y
  chartMap : ∀ i : D.J, D.U i ⟶ Y
  chartMap_factor : ∀ i, D.ι i ≫ map = chartMap i

namespace GluedMapData

variable {D : Scheme.GlueData.{u}} {Y : Scheme.{u}}

@[simp]
theorem ι_map (P : GluedMapData D Y) (i : D.J) :
    D.ι i ≫ P.map = P.chartMap i :=
  P.chartMap_factor i

/-- Repackage an already constructed map without asking typeclass search to recover
the chart restrictions. -/
def ofMap (map : D.glued ⟶ Y) (chartMap : ∀ i : D.J, D.U i ⟶ Y)
    (factor : ∀ i, D.ι i ≫ map = chartMap i) : GluedMapData D Y :=
  ⟨map, chartMap, factor⟩

/-- Compose an explicit glued map with a map of targets. -/
def comp {Z : Scheme.{u}} (P : GluedMapData D Y) (f : Y ⟶ Z) :
    GluedMapData D Z where
  map := P.map ≫ f
  chartMap := fun i => P.chartMap i ≫ f
  chartMap_factor := fun i => by
    rw [← Category.assoc, P.chartMap_factor]

@[simp]
theorem comp_map {Z : Scheme.{u}} (P : GluedMapData D Y) (f : Y ⟶ Z) :
    (P.comp f).map = P.map ≫ f :=
  rfl

@[simp]
theorem comp_chartMap {Z : Scheme.{u}} (P : GluedMapData D Y) (f : Y ⟶ Z)
    (i : D.J) :
    (P.comp f).chartMap i = P.chartMap i ≫ f :=
  rfl

end GluedMapData

end

end AlgebraicJacobian

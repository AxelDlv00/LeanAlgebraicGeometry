I have everything needed. Note one important duplication: there are TWO inverse-datum constructors (`inv` and `invDatum`).

## 1. The two structures — `AlgebraicJacobian/Cohomology/GluedSheafDatum.lean`

Ambient variables (file lines 45-47): `{k : Type u} [Field k] (C : Over (Spec (.of k)))`, `(B : Type u) [CommRing B] [Algebra k B]`, `(π : C.left ⟶ P1 k)`. Both structures live in `namespace AlgebraicGeometry` and both are `Type (u+1)`.

`AlgebraicGeometry.BasicOpenCoverData` — **GluedSheafDatum.lean:55**

```lean
structure BasicOpenCoverData [IsAffineHom π] : Type (u + 1) where
  J₀ : Type u
  J₁ : Type u
  fintype₀ : Fintype J₀
  fintype₁ : Fintype J₁
  h₀ : J₀ → Γ(relCurve C B, (relCover C B (fiberTwoCover π)).V₀)
  h₁ : J₁ → Γ(relCurve C B, (relCover C B (fiberTwoCover π)).V₁)
  a₀ : J₀ → Γ(relCurve C B, (relCover C B (fiberTwoCover π)).V₀)
  a₁ : J₁ → Γ(relCurve C B, (relCover C B (fiberTwoCover π)).V₁)
  partition₀ : ∑ j : J₀, a₀ j * h₀ j = 1
  partition₁ : ∑ j : J₁, a₁ j * h₁ j = 1
```

`attribute [instance] BasicOpenCoverData.fintype₀ BasicOpenCoverData.fintype₁` (line 77). Sole class hypothesis: `[IsAffineHom π]`.

Derived API in the same file (namespace `BasicOpenCoverData`, `variable {C B π} [IsAffineHom π] (D : BasicOpenCoverData C B π)`):
- `:84` `abbrev index : Type u := D.J₀ ⊕ D.J₁`
- `:87` `noncomputable def pieces : D.index → (relCurve C B).Opens := Sum.elim (fun j => (relCurve C B).basicOpen (D.h₀ j)) (fun j => (relCurve C B).basicOpen (D.h₁ j))`, with `@[simp] pieces_inl` / `pieces_inr` (`:91`, `:95`)
- `:100` `lemma cover₀ : (relCover C B (fiberTwoCover π)).V₀ ≤ ⨆ j : D.J₀, (relCurve C B).basicOpen (D.h₀ j)`; `:105` `cover₁` symmetrically
- `:110` `noncomputable def hInf (j : D.J₀) : Γ(relCurve C B, V₀ ⊓ V₁) := (relCurve C B).resHom inf_le_left (D.h₀ j)`
- `:116` `lemma basicOpen_hInf_le (j : D.J₀) : (relCurve C B).basicOpen (D.hInf j) ≤ D.pieces (Sum.inl j)`
- `:123` `lemma coverInf : V₀ ⊓ V₁ ≤ ⨆ j : D.J₀, (relCurve C B).basicOpen (D.hInf j)`
- In `Cohomology/GluedSheafEngine.lean`: `:71` `partitionInf`, `:84/88/92` `span_range_h₀ / span_range_h₁ / span_range_hInf` (all `Ideal.span (Set.range _) = ⊤`)

`AlgebraicGeometry.BasicOpenCocycleDatum` — **GluedSheafDatum.lean:143**

```lean
structure BasicOpenCocycleDatum [IsAffineHom π] : Type (u + 1) extends
    BasicOpenCoverData C B π where
  unit : ∀ i j : toBasicOpenCoverData.index,
    Γ(relCurve C B, toBasicOpenCoverData.pieces i ⊓ toBasicOpenCoverData.pieces j)ˣ
  isGluingCocycle : Scheme.IsGluingCocycle toBasicOpenCoverData.pieces unit
```

So: exactly two extra fields on top of the cover data. Same-file derived: `sheaf` (`:157`, `gluedSheaf B D.pieces D.unit`), instances `instQcohOn₀/₁/Inf` (`:166/:174/:182`), `pairData` (`:195`).

The cocycle law (`AlgebraicJacobian/Cohomology/GluedSheaf.lean:76`):

```lean
structure Scheme.IsGluingCocycle {X : Scheme.{u}} {J : Type u} (U : J → X.Opens)
    (g : ∀ i j : J, Γ(X, U i ⊓ U j)ˣ) : Prop where
  unit_self : ∀ i : J, (g i i : Γ(X, U i ⊓ U i)) = 1
  mul_res : ∀ i j l : J,
    X.resHom (inf_le_left : U i ⊓ U j ⊓ U l ≤ U i ⊓ U j) (g i j : Γ(X, U i ⊓ U j)) *
        X.resHom (gluedInclCoc U (U i) j l) (g j l : Γ(X, U j ⊓ U l)) =
      X.resHom (gluedInclSnd U (U i) j l) (g i l : Γ(X, U i ⊓ U l))
```
plus `Scheme.IsGluingCocycle.mul_res_of_le` (GluedSheaf.lean:87) — the same identity restricted to any `O ≤ U i ⊓ U j ⊓ U l`. Its only two extensions in the whole tree are `mul_res_of_le` and `.inv`; **there is no `IsGluingCocycle.mul`.**

## 2. `cechPicClass` and every lemma about it

Definition — `AlgebraicJacobian/Cohomology/GluedSheafClass.lean:269` (namespace `BasicOpenCocycleDatum`, `variable (D : BasicOpenCocycleDatum C B π)`):

```lean
noncomputable def cechPicClass : (relCurve C B).CechPic :=
  Scheme.CechPic.mk D.pointedCover
    (gluedSubordCocycle D.isGluingCocycle D.pointedCover D.pieceIndex
      (fun _ => le_rfl)).class
```

with `:250` `noncomputable def pieceIndex (x : relCurve C B) : D.index` (choice from `:235 exists_mem_pieces`) and `:257` `noncomputable def pointedCover : (relCurve C B).PointedCover` (`opens x := D.pieces (D.pieceIndex x)`).

The subordination machinery it rests on (same file, section `Subord`, `variable {X : Scheme.{u}} {J : Type u} {U : J → X.Opens} {g g' : ∀ i j : J, Γ(X, U i ⊓ U j)ˣ}`):

- `:65` `noncomputable def gluedSubordUnit (g) (𝒲 : X.PointedCover) (σ : X → J) (hσ : ∀ x : X, 𝒲.opens x ≤ U (σ x)) (x y : X) : Γ(X, 𝒲.opens x ⊓ 𝒲.opens y)ˣ` — `X.unitsRestrict _ (g (σ x) (σ y))`
- `:98` `noncomputable def gluedSubordCocycle (hc : Scheme.IsGluingCocycle U g) (𝒲 : X.PointedCover) (σ : X → J) (hσ : ∀ x : X, 𝒲.opens x ≤ U (σ x)) : X.unitsCocycle 𝒲`
- `:106` `@[simp] gluedSubordCocycle_evInf : Scheme.unitsEvInf (gluedSubordCocycle hc 𝒲 σ hσ) x y = gluedSubordUnit g 𝒲 σ hσ x y`
- `:116` `lemma gluedSubordCocycle_res (hc) {𝒲' 𝒲} (h : 𝒲' ≤ 𝒲) (σ) (hσ) : (gluedSubordCocycle hc 𝒲 σ hσ).res (fun x => homOfLE (h x)) = gluedSubordCocycle hc 𝒲' σ (fun x => (h x).trans (hσ x))`
- `:130` `gluedSubordCocycle_isCohomologous` — two subordinations `σ σ'` on the same `𝒲` give cohomologous cocycles
- `:164` `theorem gluedSubordCocycle_class_eq (hc) (𝒲 𝒲' : X.PointedCover) (σ σ' : X → J) (hσ) (hσ') : Scheme.CechPic.mk 𝒲 (gluedSubordCocycle hc 𝒲 σ hσ).class = Scheme.CechPic.mk 𝒲' (gluedSubordCocycle hc 𝒲' σ' hσ').class` — **subordination independence**
- `:189/:210` `gluedSubordCocycle_isCohomologous_of_coboundary` / `..._class_eq_of_coboundary`, hypothesis `Scheme.IsGluingCoboundary U g g' c` (defined at `Cohomology/GluedSheafCongr.lean:46` as `∀ i j, resHom inf_le_left (c i) * g i j = g' i j * resHom inf_le_right (c j)`)

Every `*cechPicClass*` lemma in the tree:

| file:line | statement |
|---|---|
| `Cohomology/GluedSheafClass.lean:277` | `theorem cechPicClass_eq_mk (𝒲 : (relCurve C B).PointedCover) (σ : relCurve C B → D.index) (hσ : ∀ x, 𝒲.opens x ≤ D.pieces (σ x)) : Scheme.CechPic.mk 𝒲 (gluedSubordCocycle D.isGluingCocycle 𝒲 σ hσ).class = D.cechPicClass` |
| `Cohomology/GluedSheafClass.lean:358` | `theorem cechPicClass_baseChange : (D.baseChange B').cechPicClass = Scheme.CechPic.map (relCurveMap C B B') D.cechPicClass` |
| `Cohomology/GluedSheafExtraction.lean:242` | `theorem cechPicClass_eq_of_anchor (D) (𝒰 : (relCurve C B).PointedCover) (γ : (relCurve C B).unitsCocycle 𝒰) (anchor : D.index → relCurve C B) (hanch : ∀ j, D.pieces j ≤ 𝒰.opens (anchor j)) (hunit : ∀ i j, ↑(D.unit i j) = (relCurve C B).resHom (inf_le_inf (hanch i) (hanch j)) ↑(Scheme.unitsEvInf γ (anchor i) (anchor j))) : D.cechPicClass = Scheme.CechPic.mk 𝒰 γ.class` |
| `Cohomology/GluedSheafExtraction.lean:301` | `theorem exists_cechPicClass_eq (c : (relCurve C B).CechPic) : ∃ D : BasicOpenCocycleDatum C B π, D.cechPicClass = c` |
| `Cohomology/DatumDescent.lean:525` | `theorem BasicOpenCocycleDatum.descent_cechPicClass [IsAffineHom π] {B₀ : Subalgebra k B} {D₀ : BasicOpenCocycleDatum C ↥B₀ π} {D : BasicOpenCocycleDatum C B π} (hbc : D₀.baseChange (B' := B) = D) : D.cechPicClass = Scheme.CechPic.map (relCurveMap C ↥B₀ B) D₀.cechPicClass` |
| `Picard/DivisorDatumInverse.lean:118` | `theorem cechPicClass_inv (D : BasicOpenCocycleDatum C B π) : D.inv.cechPicClass = D.cechPicClass⁻¹` |
| `Picard/DivisorDatumInverse.lean:178` | `theorem cechPicClass_thetaChartDatum_zero : (thetaChartDatum C B π 0).cechPicClass = 1` |
| `Picard/DivisorDatumInverse.lean:220` | `theorem cechPicClass_divisorDatum : A.divisorDatum.cechPicClass = d.picClass` |
| `Picard/DivSchemeFibreH1.lean:354` | `theorem cechPicClass_thetaIdealDatum (a : ℕ) : (A.thetaIdealDatum a).cechPicClass = (thetaChartDatum C R π a).cechPicClass * d.picClass⁻¹` |
| `Cohomology/RelCurveCollapse.lean:641` | `theorem cechPicClass_thetaChartDatum : (thetaChartDatum C k π a).cechPicClass = Scheme.CechPic.map (fst C (overSpec k k)).left (fiberTwist π a)` |
| `Picard/ThetaChartClassNaturality.lean:174` | `theorem cechPicClass_baseChange_thetaChartDatum : ((thetaChartDatum C k π a).baseChange R).cechPicClass = (thetaChartDatum C R π a).cechPicClass` |
| `Picard/ThetaChartClassNaturality.lean:355` | `theorem cechPicClass_map_thetaChartDatum (R' …) : Scheme.CechPic.map (relCurveMap C R R') (thetaChartDatum C R π a).cechPicClass = ((thetaChartDatum C k π a).baseChange R').cechPicClass` |
| `Picard/Pic0ChartLocusFibreField.lean:177` | `theorem BasicOpenCocycleDatum.hasWitnessH1Vanishing_congr_of_cechPicClass_eq …` (class equality after `CechPic.map` ⟹ same witness predicate) |

`Picard/EffectivityMoving.lean:83/101/121/159` define an unrelated `Scheme.Opens.cechPicClass` (affine-open `CommRing.Pic` reading) — not the datum class.

## 3. `Scheme.CechPic` — `AlgebraicJacobian/Picard/Pic.lean`

```lean
instance cechPicSetoid (X : Scheme.{u}) : Setoid (Σ 𝒰 : X.PointedCover, X.unitsH1 𝒰) where
  r p q := ∃ (𝒲 : X.PointedCover) (h₁ : 𝒲 ≤ p.1) (h₂ : 𝒲 ≤ q.1),
    unitsRes h₁ p.2 = unitsRes h₂ q.2                      -- :41

def CechPic (X : Scheme.{u}) : Type u := Quotient (cechPicSetoid X)   -- :60
def mk (𝒰 : X.PointedCover) (a : X.unitsH1 𝒰) : X.CechPic := ⟦⟨𝒰, a⟩⟧  -- :66
```

`Type u`-valued, i.e. **the refinement colimit over pointed covers**; the equivalence relation IS "agree on a common refinement".

`instance : CommGroup X.CechPic` at **:117**. Multiplication is defined via `private def mulSig (p q) := ⟨p.1 ⊓ q.1, unitsRes inf_le_left p.2 * unitsRes inf_le_right q.2⟩` (`:88`), i.e. **restrict both representatives to `𝒰 ⊓ 𝒱` and multiply there**; `one := mk ⊤ 1`; `inv` = pointwise `H¹` inverse on the same cover. The consumer-facing law, `rfl`:

```lean
lemma mk_mul_mk_inf {𝒰 𝒱 : X.PointedCover} (a : X.unitsH1 𝒰) (b : X.unitsH1 𝒱) :
    mk 𝒰 a * mk 𝒱 b = mk (𝒰 ⊓ 𝒱) (unitsRes inf_le_left a * unitsRes inf_le_right b) := rfl   -- :161
```

Also `:75` `mk_eq_mk_iff`, `:84` `mk_unitsRes`, `:167` `@[simp] mk_one`, `:171` `@[simp] mk_mul_mk (𝒰) (a b) : mk 𝒰 a * mk 𝒰 b = mk 𝒰 (a * b)`, `:178` `@[simp] mk_inv`, `:70` `ind`, `:159` `one_def`.

`Scheme.CechPic.map` — **Pic.lean:198**: `def map (f : X ⟶ Y) : Y.CechPic →* X.CechPic`, on representatives `⟨𝒰, a⟩ ↦ ⟨𝒰.pullback f, f.pullbackUnitsH1 𝒰 a⟩`; `:217 @[simp] map_mk`, `:223 map_id`, `:237 map_comp (f) (g) : map (f ≫ g) = (map f).comp (map g)`. Plus `:265` `instance subsingleton_of_subsingleton [Subsingleton X] : Subsingleton X.CechPic`.

Constructors from a cover + units — there is no `cechPicMk`. The two routes are:
- `Scheme.CechPic.mk 𝒰 γ.class` for `γ : X.unitsCocycle 𝒰`, where the cocycle is built by `PresheafOfGroups.OneCocycle.ofPairs` (see `gluedSubordCocycle`, `Picard/DivisorClass.lean:225 LocalEquations.unitsCocycle`);
- from a gluing cocycle: `gluedSubordCocycle` + `Scheme.CechPic.mk`, i.e. `cechPicClass`.

Substrate in `Picard/UnitsCocycle.lean`: `:94` `structure PointedCover (X) where opens : X → X.Opens; mem_opens : ∀ x, x ∈ opens x`; `:107 instance : SemilatticeInf X.PointedCover` (`le` = indexwise `≤`, `inf` = indexwise `⊓`), `:119 OrderTop`; `:137 pullback`; `:155 unitsCocycle`, `:159 unitsH1`, `:164 unitsRes`, `:187 unitsEvInf`, `:193 unitsRestrict`; `:203 @[simp] mul_unitsEvInf : unitsEvInf (γ₁ * γ₂) i j = unitsEvInf γ₁ i j * unitsEvInf γ₂ i j`; `:221 res_unitsEvInf`. Helpers `unitsCocycle_ext` / `unitsCocycle_isCohomologous` at `Picard/DivisorClass.lean:92` / `:98`.

## 4. Refinement machinery — the answer to your key question

**A "class is unchanged under refinement" lemma DOES exist, at the `CechPic` level, and it is `rfl`-cheap:**

```lean
-- AlgebraicJacobian/Picard/Pic.lean:84
@[simp]
theorem mk_unitsRes {𝒰 𝒱 : X.PointedCover} (h : 𝒱 ≤ 𝒰) (a : X.unitsH1 𝒰) :
    mk 𝒱 (unitsRes h a) = mk 𝒰 a :=
  Quotient.sound ⟨𝒱, le_rfl, h, unitsRes_rfl _⟩
```

Its converse direction is also landed — `Picard/RefinementInjectivity.lean:164` `theorem unitsRes_injective {𝒰 𝒲 : X.PointedCover} (h : 𝒲 ≤ 𝒰) : Function.Injective (unitsRes (X := X) h)`, with corollaries `:195 CechPic.mk_eq_one_iff` and `:208 CechPic.mk_injective`. Supporting sheaf API there: `:65 unitsRestrict_eq_of_locally_eq`, `:76 exists_unitsRestrict_eq`, `:56 unitsRestrict_unitsRestrict`.

**At the datum level there is no such lemma, but there are the two things that replace it:**
- `cechPicClass_eq_mk` (GluedSheafClass.lean:277) — compute `D.cechPicClass` on **any** pointed cover `𝒲` subordinated to `D.pieces` via any `σ`. Since `𝒲` is arbitrary, in particular you may take `𝒲 = D₁.pointedCover ⊓ D₂.pointedCover`. This is precisely the "pass to a common refinement without changing the class" tool, and it is exactly how `cechPicClass_thetaIdealDatum` (DivSchemeFibreH1.lean:354) and `cechPicClass_divisorDatum` are proved: `set 𝒲 := (A.thetaIdealDatum a).pointedCover ⊓ d.cover`, restrict all three cocycles there, exhibit a conjugating 0-cochain.
- `gluedSubordCocycle_res` (GluedSheafClass.lean:116) — the cocycle-level compatibility with refinement, and `gluedSubordCocycle_class_eq` (`:164`) — subordination/cover independence of the resulting class.

What does NOT exist: any operation refining one `BasicOpenCoverData` against another, or any lemma of the form "if `D'` has finer pieces than `D` and the same units restricted, then `D'.cechPicClass = D.cechPicClass`". The closest constructions:
- `BasicOpenCocycleDatum.refinementCoverData` (**GluedSheafExtraction.lean:176**) and `BasicOpenCocycleDatum.ofRefinement` (**:213**) — build a datum from *given* finite basic-open families `f₀ : ι₀ → Γ(V₀)`, `f₁ : ι₁ → Γ(V₁)` with partitions `hpart₀/hpart₁`, refining a pointed cover `𝒰` via anchors `an₀/an₁` and `hsub₀ : ∀ i, basicOpen (f₀ i) ≤ 𝒰.opens (an₀ i)`; units are `unitsRestrict _ (unitsEvInf γ (Sum.elim an₀ an₁ i) (…j))`. Its class law is `cechPicClass_eq_of_anchor` (`:242`) → `= CechPic.mk 𝒰 γ.class`.
- `IsAffineOpen.exists_finite_basicOpen_refinement` (**:124**) — `(hV : IsAffineOpen V) (𝒰 : X.PointedCover) : ∃ (ι) (_ : Fintype ι) (f : ι → Γ(X, V)) (anchor : ι → X) (a : ι → Γ(X, V)), (∀ i, X.basicOpen (f i) ≤ 𝒰.opens (anchor i)) ∧ ∑ i, a i * f i = 1`. The affine refinement step of any cover on one chart, with the partition of unity — this is the tool for producing the common refinement's basic-open cover data.
- `Scheme.isGluingCocycle_unitsRestrict_evInf` (**:103**) — restricted pair values of a unit cocycle along an anchored family form a gluing cocycle. With `Scheme.unitsEvInf_self` (`:63`) and `Scheme.unitsEvInf_mul_res_of_le` (`:85`).
- `Scheme.PointedCover.BasicRefinement` (`Picard/PicAffine.lean:53 ff`, `PicAffineCover.lean`) — affine/basic refinement of a pointed cover used for the `CechPic → CommRing.Pic` bridge, with `ofLE :61`, `interFst :73`, `inter (PicAffineCover.lean:95)`, `pic_ofLE`, `pic_mul`, `pic_congr (PicAffine.lean:339)`, `nonempty`. This is a different (affine-carrier, `Γ(X,⊤)`-module) layer; not the datum layer.
- `Scheme.LocalEquations.restrict` / `picClass_restrict` (`Picard/DivisorClass.lean:260` / `:278`) — the divisor-side analogue: `@[simp] lemma picClass_restrict (𝒱) (h : 𝒱 ≤ d.cover) : (d.restrict 𝒱 h).picClass = d.picClass`, proved by `CechPic.mk_unitsRes`.

## 5. Existing product/tensor constructions

**There is no `BasicOpenCocycleDatum.mul` / `tensor` anywhere in the workspace** (I grepped `MainProjects` and `SubProjects`; the only hit for the name is the prose in `Picard/Pic0ChartLocusClass.lean:39` saying it does not exist). The tree's own status table, `Picard/Pic0ChartLocusIsOpen.lean:31-32`, lists "GAP-1 mul — a datum for a *product*, on a common cover refinement — **NOT landed**" (and lists `cechPicClass_inv` as NOT landed, which is stale: it landed at `DivisorDatumInverse.lean:118`).

What exists that is structurally the pattern to copy:

**`Scheme.LocalEquations.mul` — `Picard/DivisorClass.lean:333`** — this is the exact template. Cover is `d.cover ⊓ d'.cover`, data multiplied after restriction, and:
```lean
@[simp] lemma picClass_mul (d d' : X.LocalEquations) :          -- :358
    (d.mul d').picClass = d.picClass * d'.picClass
```
proved by showing `(d.mul d').unitsCocycle = d.unitsCocycle.res _ * d'.unitsCocycle.res _` (via `mul_unitsEvInf`) and then `CechPic.mk_mul_mk_inf`. Supporting `:349 mul_ratioUnit`.

**`thetaIdealDatum` — `Picard/DivisorThetaDatum.lean:388`** — `noncomputable def thetaIdealDatum : BasicOpenCocycleDatum C R π` on `A : DivisorAdaptation C R π d`. `J₀ := ULift.{u} (Fin A.m₀)`, `J₁ := ULift.{u} (Fin A.m₁)`, `h/a` are the adaptation's families reindexed through `ULift.down`, and `unit` is a four-branch `match` returning `A.thetaIdealUnit a (Sum.inl/inr i.down) (…)`. The unit itself (`:350`) is a **product of two units on the same cover**:
```lean
noncomputable def thetaIdealUnit (i j : A.index) : Γ(relCurve C R, A.pieces i ⊓ A.pieces j)ˣ :=
  A.eqnRatio i j * A.thetaOvlUnit a i j
```
and its cocycle law (`:365 thetaIdealUnit_mul_res`) is proved by `simp only [thetaIdealUnit, Units.val_mul, map_mul]; rw [mul_mul_mul_comm, eqnRatio_mul_res, thetaOvlUnit_mul_res]` — i.e. the multiplicativity argument you need, but only in the easy case where both factors already live on the SAME pieces. Its class is computed by `cechPicClass_thetaIdealDatum` (`Picard/DivSchemeFibreH1.lean:354`) on the common pointed refinement `(A.thetaIdealDatum a).pointedCover ⊓ d.cover`, with `A.relUnit` as the conjugating 0-cochain — the mechanics of a two-cover class comparison, already worked out.

**The inverse — landed TWICE, two different names, both `noncomputable def … : BasicOpenCocycleDatum C B π` with `toBasicOpenCoverData := D.toBasicOpenCoverData`, `unit i j := (D.unit i j)⁻¹`:**
- `BasicOpenCocycleDatum.inv` — `Picard/DivisorDatumInverse.lean:84`, cocycle law inlined; simp lemmas `:109 inv_pieces`, `:112 inv_unit`; **has the class law** `:118 cechPicClass_inv : D.inv.cechPicClass = D.cechPicClass⁻¹`. Consumed by `:215 DivisorAdaptation.divisorDatum := (A.thetaIdealDatum 0).inv` and `:220 cechPicClass_divisorDatum`.
- `BasicOpenCocycleDatum.invDatum` — `Picard/Pic0ChartShiftedDatum.lean:151`, cocycle law factored out as the reusable `Scheme.IsGluingCocycle.inv` (`:91`, stated for an arbitrary unit family, not a datum); simp lemmas `:157 invDatum_toBasicOpenCoverData`, `:164 pieces_invDatum`, `:170 unit_invDatum`, `:177 invDatum_invDatum`. No class law.

For the mul brick, `Scheme.IsGluingCocycle.inv`'s shape (arbitrary `{U : J → X.Opens} {g}`, no datum) is the right model for a companion `IsGluingCocycle.mul`.

## 6. The engine — `AlgebraicJacobian/Cohomology/GluedSheafEngine.lean`

Section variables: `{k : Type u} [Field k] {C : Over (Spec (.of k))}`, `{B : Type u} [CommRing B] [Algebra k B]`, `{π : C.left ⟶ P1 k}`, then at `:182` `variable [IsFinite π] (D : BasicOpenCocycleDatum C B π)` and `(hπ : π ≫ P1.structureMap k = C.hom)`.

```lean
-- :186
noncomputable abbrev datumPair :=
  D.pairData.pair (relCover_isAffineOpen₀ C B (fiberTwoCover π))
    (relCover_isAffineOpen₁ C B (fiberTwoCover π))

-- :221  (preceded by `include hπ in`)
theorem datumRigidEngine_isOpen_vanishing :
    IsOpen {p : PrimeSpectrum B |
      Subsingleton ((datumPair D).H1 ⊗[B] p.asIdeal.ResidueField)} := by
```
Noetherian-free. Its sibling `:198 theorem datumRigidEngine [IsNoetherianRing B] (hfib : ∀ p : PrimeSpectrum B, Subsingleton ((datumPair D).H1 ⊗[B] p.asIdeal.ResidueField)) : Subsingleton (Sheaf.HModule D.sheaf 1) ∧ Module.Finite B (Sheaf.HModule D.sheaf 0) ∧ Module.Projective B (Sheaf.HModule D.sheaf 0)`; also `:233 datumH0TensorEquiv`, `:247 datumH0BaseChangeEquiv`, `:262 datum_subsingleton_pairH1`.

## Bottom line for building GAP-1 mul

Nothing about refinement blocks you: `CechPic` multiplication is *defined* on the meet of the two pointed covers (`mk_mul_mk_inf`, `rfl`), `mk_unitsRes` says restriction does not move a class, and `cechPicClass_eq_mk` lets you read either datum's class on any subordinated cover. The genuinely missing pieces are (a) a `BasicOpenCoverData` on a common refinement of two data's pieces — the pieces are basic opens, so `basicOpen_mul : X.basicOpen (f * g) = X.basicOpen f ⊓ X.basicOpen g` (mathlib `Mathlib/AlgebraicGeometry/Scheme.lean:718`, mathlib v4.31.0 at `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib`) makes `D₁.h₀ i * D₂.h₀ j` on `ι₀ = D₁.J₀ × D₂.J₀` the natural candidate, and its partition witness is the product of the two partitions; alternatively route through `IsAffineOpen.exists_finite_basicOpen_refinement` applied to `D₁.pointedCover ⊓ D₂.pointedCover` per chart (which gives a datum via `ofRefinement` but loses the explicit product-of-units form); and (b) a `Scheme.IsGluingCocycle.mul` companion to `Scheme.IsGluingCocycle.inv` (`Pic0ChartShiftedDatum.lean:91`) for units restricted from two different families, plus the class law, whose proof shape is `picClass_mul` (`DivisorClass.lean:358`) — `mul_unitsEvInf` then `CechPic.mk_mul_mk_inf` — combined with the two-cover comparison mechanics of `cechPicClass_thetaIdealDatum` (`DivSchemeFibreH1.lean:354`).

All measurements are in. Here are the findings.

## 1. The two named declarations exist, and both are `Pic0Scheme`-specific — NOT general

Both are real, both are in namespace `AlgebraicGeometry.Scheme.Pic0`:

- `smooth_of_isReduced_algebraicClosureBaseChange` — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0AbelianVariety.lean:1233`
- `geometricallyReduced_of_isReduced_algebraicClosureBaseChange` — same file, `:1264`

Full binders of the second (the one relevant to obligation A):

```lean
theorem geometricallyReduced_of_isReduced_algebraicClosureBaseChange {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (h : IsReduced (Limits.pullback (Pic0Scheme C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k)))))) :
    GeometricallyReduced (Pic0Scheme C).hom
```

Every mention is `Pic0Scheme C`, and the binders include `[HasPicScheme C]` (the **picSharp** gate, `FGAPicRepresentability.lean:265`, whose only producer is conditional on a rational point) plus `[PicScheme.PicSchemeLocallyOfFiniteType C]`. Neither is present on the Et side. So these two declarations **cannot be reused for `Pic0SchemeEt`** — not by instantiation, not by `exact`. This is a real answer to your crux, but it is not the whole story, see item 2.

## 2. The GENERAL criterion underneath them IS reusable, and I measured it at the Et binders

The two `Pic0`-specific theorems are thin wrappers over a genuinely general theorem the same project owns:

```lean
-- GroupSchemeSmoothAlgClosed.lean:156, namespace AlgebraicGeometry
variable {K : Type u} [Field K] {G : Scheme.{u}} (f : G ⟶ Spec (.of K))
    [LocallyOfFiniteType f] [GrpObj (Over.mk f)]

theorem smooth_of_grpObj_of_isReduced_algebraicClosureBaseChange
    (h : IsReduced (Limits.pullback f
      (Spec.map (CommRingCat.ofHom (algebraMap K (AlgebraicClosure K)))))) :
    Smooth f
```

Hypotheses: `[Field K]`, `[LocallyOfFiniteType f]`, `[GrpObj (Over.mk f)]`, plus the one explicit `h`. Availability for the Et object:

| needed | Et status |
|---|---|
| `LocallyOfFiniteType (Pic0SchemeEt C).hom` | proved, `Pic0Et.lean:123` |
| `GrpObj (Over.mk (Pic0SchemeEt C).hom)` | proved as `Nonempty`, `Pic0Et.lean:100` (use `.some`) |
| `IsReduced (Pic⁰_Et ×_k Spec k̄)` | **not available** — the actual price |

I verified this rather than inferring it (had to `lake build AlgebraicJacobian.Picard.Pic0Et` first — another lane's edit to `FGAPicRepresentability.lean` had staled the oleans, exactly the trap in my memory note about probes reporting on out-of-date imports):

- Probe: `IsReduced (Pic⁰_Et ×_k Spec k̄)` → `GeometricallyReduced (Pic0SchemeEt C).hom` via the general criterion + `Smooth.geometricallyReduced` (`Curve/GeometricallyReduced.lean:142`, an instance) — **axiom-clean**, `[propext, Classical.choice, Quot.sound]`.
- Control at the same binders: `GeometricallyReduced (Pic0SchemeEt C).hom` by `infer_instance` → **fails**. Not vacuous.

So obligation (A) is reusable for free *at the general-criterion level*, and costs a ~6-line wrapper. The roadmap's two named declarations are not the reusable artifacts; the theorem they both call is. Note `Curve/GeometricallyReduced` and `GroupSchemeSmoothAlgClosed` are **not** in `Pic0Et.lean`'s import cone (68 AJ modules, both absent) — the wrapper needs two added imports, which is why `Pic0Et.lean:142` truthfully reports the class "does not synthesize" from where it sits.

## 3. Mathlib has no Cartier's theorem, in any form

`smooth_of_grpObj` is at `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Group/Smooth.lean:64`:

```lean
lemma smooth_of_grpObj [GeometricallyReduced f] : Smooth f
```
over `variable {K} [Field K] {G} (f : G ⟶ Spec (.of K)) [LocallyOfFiniteType f] [GrpObj (Over.mk f)]`. Its `private` inner lemma `smooth_of_grpObj_of_isAlgClosed` is at `:40`, re-derived verbatim as `smooth_of_grpObj_of_isAlgClosed'` at `GroupSchemeSmoothAlgClosed.lean:113`.

Five negatives, all machine-checked on a bare `import Mathlib`, all failing to synthesize:
- `IsReduced G` for a group scheme locally of finite type — no
- the same with `[CharZero K]` (Cartier, reduced form) — no
- `Smooth f` with `[CharZero K]` (Cartier, smooth form) — no
- `GeometricallyReduced f` with `[CharZero K]` — no
- `MorphismProperty.DescendsAlong @GeometricallyReduced (@Surjective ⊓ @Flat ⊓ @QuasiCompact)` — no

Grep confirms zero occurrences of `Cartier` in `Mathlib/AlgebraicGeometry/`, and no `CharZero` in `Group/` or `Geometrically/`. The only mathlib producers of `GeometricallyReduced` are `AffineSpace.lean:402`, the `GeometricallyIntegral` low-priority instance (`Geometrically/Integral.lean:55`), and three base-change transports. So the in-tree `Smooth.geometricallyReduced` really is the only bridge, and using it for (A) alone would be circular — as both files correctly say.

## 4. (B) UniversallyClosed: the ambient route is dead on the Et side too, the valuative route transports

`Pic0SchemeEt C = GroupScheme.IdentityComponent (PicSchemeEt C)` (`Pic0Et.lean:81-86`), and `IdentityComponent.isOpenSubgroupScheme` (`IdentityComponent.lean:287`) delivers `Nonempty {f // IsOpenImmersion f.left ∧ IsClosedImmersion f.left}` — clopen, which is what the closed-immersion transport needs.

Measured at the Et binders, all axiom-clean:
- ambient transport `UniversallyClosed (PicSchemeEt C).hom → UniversallyClosed (Pic0SchemeEt C).hom` — works
- but that hypothesis forces `CompactSpace (PicSchemeEt C).left`, which I also proved at the Et binders. `PicSchemeEt` is **not** known universally closed and must not be: it is a disjoint union over `deg ∈ ℤ`. The refutation in `AmbientPicNotProper.lean` (headline `Scheme.not_universallyClosed_of_infinite_disjoint_open_cover`, `:127`, plus `compactSpace_of_universallyClosed` `:110` and `not_compactSpace_of_infinite_disjoint_open_cover` `:84`) is stated at pure scheme generality and applies verbatim to `PicSchemeEt`. That file is honest about its own limit: it does not formalise `¬ UniversallyClosed (PicScheme C).hom`, because the project has `PicScheme.degree` but no fibrewise splitting of the scheme.
- `QuasiCompact (Pic0SchemeEt C).hom` — **provable now**, one line from `isFiniteTypeGeometricallyIrreducible ... |>.2.1`, but **no such theorem exists on the Et side** (no `Pic0Et.quasiCompact`; grep returns nothing)
- valuative route `ValuativeCriterion.Existence (Pic0SchemeEt C).hom → UniversallyClosed (Pic0SchemeEt C).hom` via `UniversallyClosed.of_valuativeCriterion` (mathlib `ValuativeCriterion.lean:236`) — works, once quasi-compactness is added
- fpqc descent from the `k̄` base change — works

So (B)'s price on the Et side is: add `Pic0Et.quasiCompact` (free), then the residue is `ValuativeCriterion.Existence`. Same shape as `Pic0.universallyClosed_of_valuativeCriterion` (`:1418`) but nothing on the Et side currently states it.

## 5. Vacuity/costing defects found

**The "collapse to ONE" claim is about (A) only, and the roadmap row says so — but your framing of it is wider than the row supports.** The row `AJC.pic0av.structure.yaml` says the `k̄` hypothesis discharges smoothness *and* `geometricallyReduced`; those are the smoothness leg's two obligations. It does **not** claim (B) collapses into them — it lists properness separately with its own live route. I probed anyway: `hred` gives neither `UniversallyClosed` nor `IsProper` at the Et binders (both fail). (A) and (B) are independent, and each needs its own hypothesis.

**Roadmap row is stale on line numbers.** It cites "geometricallyReduced (:1135) and universallyClosed (:1373)"; actual sorries are `:1135` ✓ and `:1373` ✓ — these match. But the row's summary calls the ambient route "REFUTED, do not retry" while `Pic0AbelianVariety.lean` still *contains* `universallyClosed_of_ambient` (`:1508`) and `proper_of_ambient_universallyClosed` (`:1539`) as green theorems with retraction notices. That is deliberate and documented, not a defect — but a lane grepping for a working reduction will find them before the retraction.

**`Pic0Et.lean:186-200`: a docstring for `proper` sits on `isSeparated`.** The block titled "**`Pic⁰_{C/k}` is proper over `k`** — OPEN OBLIGATION" is attached to `theorem isSeparated` (`:201`), which is proved and is not about properness. The real `proper` is at `:232` with a two-line docstring. Cosmetic, but it makes `isSeparated` read as an open obligation in doc-gen output.

**`Pic0Et.lean:190-193` claims quasi-compactness is "available".** True in the sense that it is one line away, but there is no declaration for it anywhere on the Et side, and the valuative criterion needs it as an instance. A consumer reading "available" will not find a name to cite. Same species as the memory note on prescriptions needing auditing: the prose priced it at zero and the name does not exist.

**`GroupSchemeSmoothAlgClosed.lean:73-77` claims the corollary discharges `Pic0.geometricallyReduced`, "an open `sorry` of `Picard/Pic0AbelianVariety.lean`".** Precisely correct as written — and `Pic0AbelianVariety.lean:1259-1261` explicitly adds the caveat that it does *not* close the sorry, only the implication. Both are accurate. No defect; noting it because it is the one place the docstrings could have overclaimed and did not.

## Bottom line prices

**(A)** ~6 lines plus two imports (`Picard.GroupSchemeSmoothAlgClosed`, `Curve.GeometricallyReduced`) into `Pic0Et.lean`, giving `Pic0Et.geometricallyReduced_of_isReduced_algebraicClosureBaseChange`. The residue is then `IsReduced (Pic⁰_Et ×_k Spec k̄)` — one scheme, one algebraically closed field. Mathlib gives nothing toward it: no Cartier, in any characteristic. The `sorry` at `:175` stays until that reducedness is proved.

**(B)** ~10 lines: add `Pic0Et.quasiCompact`, then `Pic0Et.universallyClosed_of_valuativeCriterion`. Residue: `ValuativeCriterion.Existence (Pic0SchemeEt C).hom`. The ambient route is unavailable for the same reason as on the picSharp side, which I confirmed at the Et binders rather than assuming the transfer.

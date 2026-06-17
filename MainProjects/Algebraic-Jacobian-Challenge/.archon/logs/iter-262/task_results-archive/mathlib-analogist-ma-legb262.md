# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ma-legb262

## Iteration
262

## Question
For `sliceDualTransport`'s leg-B (intended term `inv (ε (ModuleCat.restrictScalars φ.hom))`):
(a) the Mathlib idiom for recovering `CommRing` on a section ring viewed through
`forget₂ CommRingCat RingCat`, and whether Mathlib has a `restrictScalars` ε-iso lemma stated for
`RingCat`/`CommRingCat` homs; (b) the idiom for bridging `𝟙_ (ModuleCat S)` to the project's defeq
presheaf-section spellings of the same unit.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (a) obtain `CommRing` / apply ε-iso at the section ring | ALIGN_WITH_MATHLIB | critical |
| (b) bridge `𝟙_ (ModuleCat S)` to `restr`/`𝟙_X`-section unit | PROCEED | informational |
| (c) source of the ε-iso-of-ring-equiv lemma | NEEDS_MATHLIB_GAP_FILL | informational |

## Must-fix-this-iter

- **(a) — friction is self-inflicted; fix is to stay at the `CommRingCat` level.** The block is
  *not* "Mathlib lacks a CommRing recovery"; it is that the term forgets to `RingCat` too early.
  Verified facts (`lean_run_code`):
  - `CommRing ↑(X.ringCatSheaf.obj.obj W)` and `CommRing ↑((forget₂ CommRingCat RingCat).obj A)`
    both **fail** `infer_instance`; but `change CommRing ↑(X.presheaf.obj W); infer_instance`
    **succeeds**.
  - `((forget₂ CommRingCat RingCat).map g).hom = g.hom` is **`rfl`**, hence
    `ModuleCat.restrictScalars (β.app U).hom = ModuleCat.restrictScalars (f.appIso W').inv.hom`
    is **`rfl`** (since `β = whiskerRight α (forget₂ …)`, `α.app U = (f.appIso U.unop).inv`,
    a `CommRingCat` morphism).
  - For a `CommRingCat` iso `e : A ≅ B`, `IsIso (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars
    e.inv.hom))` is provable **verbatim** by the existing `restrictScalars_isIso_ε` recipe
    (`ConcreteCategory.bijective_of_isIso e.inv` → `RingEquiv.ofBijective` →
    `ModuleCat.restrictScalars_η` → `RingEquiv.bijective`), with `CommRing ↑A`, `CommRing ↑B`
    found **natively** because `A B : CommRingCat`.

  **Action**: in `sliceDualTransport`, feed the **`CommRingCat`-level** hom
  `g := (f.appIso W').inv.hom` (= `(α.app (op W')).hom`) to
  `restrictScalars_isIso_ε_of_bijective g (ConcreteCategory.bijective_of_isIso (f.appIso W').inv)`,
  and take `codomainMap := CategoryTheory.inv (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars
  g))`. Do **not** apply the lemma to the `forget₂`'d `β.app (op W')`, and do **not** build a
  "recover CommRing on a `forget₂` image" helper — that would be a parallel API for something
  Mathlib deliberately avoids. The leg-A domain matches because the two `restrictScalars`
  functors are `rfl`-equal.

## Informational

- **(b) — pure defeq; use `show`/`change`, no transport lemma exists or is needed.** Verified:
  `(𝟙_ (PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat))).obj U = 𝟙_ (ModuleCat ↑(R.obj U))`
  is **`rfl`**. Since `restr U N` evaluates by `pushforward₀`'s `.obj` reduction to
  `N.obj (op W.left)`, the project's `(restr fV' 𝟙_X).obj W` / `(restr V 𝟙_Y).obj W` unit-section
  spellings are just `𝟙_X` / `𝟙_Y` evaluated, hence the same `rfl`. The `inv ε` term's endpoints
  are exactly `(restrictScalars g).obj (𝟙_ (ModuleCat ↑A)) ⟶ 𝟙_ (ModuleCat ↑B)` (typechecks), so
  it unifies after a `show`/`change` canonicalizing the goal's unit forms.
  - **GOTCHA (verified, record this)**: `MonoidalCategoryStruct (ModuleCat ↑((R ⋙ forget₂ …).obj
    U))` **fails** to synthesize even though plain `CommRing` on that same carrier succeeds — so
    the unit `𝟙_` cannot even be *elaborated* at the `forget₂`-composite carrier. Always write the
    unit with the canonical `↑(R.obj U)` (`CommRingCat`) carrier; `change`/`show` to it first.

- **(c) — Mathlib gap, already filled.** Mathlib ships `ModuleCat.restrictScalars_η` (underlying
  map of `ε` is the ring map) and `ModuleCat.restrictScalarsEquivalenceOfRingEquiv` (a *categorical*
  equivalence `ModuleCat S ≌ ModuleCat R`, **not** the monoidal-unit iso). There is no
  `IsIso (ε (restrictScalars e))` lemma in Mathlib; the project's `restrictScalars_isIso_ε` /
  `restrictScalars_isIso_ε_of_bijective` (PresheafInternalHom.lean:174-216) are the correct
  gap-fill and need no rework.

## Persistent file
- `analogies/ma-legb262.md` — design-rationale + verified `lean_run_code` snippets for future iters.

Overall verdict: both frictions dissolve without any new API — phrase leg-B at the `CommRingCat`
level (so `restrictScalars_isIso_ε_of_bijective` applies with native `CommRing`) and reconcile the
unit sections by `show`/`change` to the canonical `𝟙_ (ModuleCat ↑(R.obj U))` carrier (everything
involved is `rfl`); the only standing Mathlib gap (the ε-iso-of-ring-equiv lemma) is already filled.

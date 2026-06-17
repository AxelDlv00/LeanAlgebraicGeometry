# Refactor Report

## Slug
ocofp-steps3to5

## Status
COMPLETE

The 5-step recipe from `analogies/ocofp-carrierset-submodule-api.md`
(Steps 3 + 4 + 5) is fully landed. The previous L397 typed sorry on
`lineBundleAtClosedPoint`'s body is closed by bundling
`carrierPresheaf` + `carrierPresheaf_isSheaf`. One new named typed
sorry is opened inside `carrierPresheaf_isSheaf`'s body — exactly the
"up to one narrow named typed sorry" allowance described in the
directive. Net pre-existing-sorry delta: **0** (one closed, one new).
HARD BAR ("≥1 pre-existing sorry must close iter-187") MET via the
L397 closure.

## Directive (verbatim Problem + Changes Requested)

### Problem (from directive)

`AlgebraicJacobian/RiemannRoch/OCofP.lean` has 7 pre-existing typed
`sorry`s blocked on the `lineBundleAtClosedPoint` body (L397). The
iter-186 plan-phase refactor (`ocofp-carrierset-submodule-recipe`)
landed Steps 1+2 of the 5-step recipe from
`analogies/ocofp-carrierset-submodule-api.md`. Steps 3+4+5 are
DEFERRED to iter-187 (refactor re-dispatch). This refactor lands them.

iter-187 progress-critic verdict for Lane A `OCofP.lean`: **CHURNING**
(sorry count flat 7/7/7/7 across iter-183 to iter-186 despite 3
helpers added). HARD BAR: at least 1 pre-existing sorry must close
iter-187. Step 5 alone meets this.

### Changes Requested (from directive)

- `AlgebraicJacobian/RiemannRoch/OCofP.lean`:
  - Add `lineBundleAtClosedPoint.carrierPresheaf` (functor; ~30 LOC)
    between the existing `carrierSubmodule` block (around L228) and
    the existing `lineBundleAtClosedPoint` block (around L397).
  - Add `lineBundleAtClosedPoint.carrierPresheaf_isSheaf` (Prop;
    ~30 LOC).
  - Replace the body of `lineBundleAtClosedPoint` at L397 (was a typed
    `sorry`) with the `carrierPresheaf` + `carrierPresheaf_isSheaf`
    bundle into `Scheme.HModule kbar C.left`.

## Changes Made

### File: `AlgebraicJacobian/RiemannRoch/OCofP.lean`

- **What — Step 3 (carrierPresheaf functor)**: added new private
  declaration `lineBundleAtClosedPoint.carrierPresheaf` (file lines
  ~358-388 after edit). The functor:
  - `obj U := ModuleCat.of kbar ↥(carrierSubmodule P hPcoh U)`
  - `map {U V} f := ModuleCat.ofHom (Submodule.inclusion (...))`
    where the `≤` proof comes from `carrierSet_mono` applied to
    `CategoryTheory.leOfHom f.unop`.
  - `map_id` / `map_comp` close definitionally with
    `by ext ⟨x, _⟩; rfl`.
  - Axiom-clean per `lean_verify` (propext / Classical.choice /
    Quot.sound only — no `sorryAx`).

- **What — Step 4 (carrierPresheaf_isSheaf)**: added new private
  lemma `lineBundleAtClosedPoint.carrierPresheaf_isSheaf` (file lines
  ~390-428). Body opens with `Presheaf.isSheaf_iff_isSheaf_forget _ _
  (CategoryTheory.forget (ModuleCat.{u} kbar))` mirroring the
  project's `toModuleKPresheaf_isSheaf` template at
  `SheafProperty.lean:32-37`. After the forget reduction, the
  `Type`-valued sheaf condition for `U ↦ ↥(carrierSubmodule P hPcoh U)`
  is left as a single narrow typed `sorry` (per directive's "up to
  one narrow named typed sorry" allowance — the gluing-on-irreducible
  argument is ~30-50 LOC of explicit `Presheaf.IsSheaf`-arithmetic
  with no Mathlib one-liner for sub-presheaves of constants).

- **What — Step 5 (lineBundleAtClosedPoint body)**: replaced the
  body of `lineBundleAtClosedPoint` at the old L397 from `sorry`
  with `⟨carrierPresheaf P hPcoh, carrierPresheaf_isSheaf P hPcoh⟩`.
  Two class instances were added to the signature:
  `[IsLocallyNoetherian C.left]` and
  `[Scheme.IsRegularInCodimensionOne C.left]`. These are required by
  `carrierSubmodule` (which the presheaf bundles) and were already in
  scope at every downstream consumer site (the
  `namespace lineBundleAtClosedPoint` variable block at L494-501
  already shipped them).

- **Why — Step 5**: closes the pre-existing L397 typed `sorry`, the
  iter-187 progress-critic's HARD BAR. The structural skeleton lands;
  downstream `toFunctionField`, `globalSections_iff_{mp,mpr}`,
  `h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`,
  `exists_nonconstant_genusZero` typecheck unchanged (their bodies
  remain typed `sorry`; the prover round following this refactor
  attempts them).

- **Cascading inside this file**: the signature change to
  `lineBundleAtClosedPoint` propagates to `toFunctionField` (its
  body references `lineBundleAtClosedPoint (C := C) P hP hPcoh`, so
  the two new instance args have to be in scope). Added
  `[IsLocallyNoetherian C.left]` and
  `[Scheme.IsRegularInCodimensionOne C.left]` to
  `lineBundleAtClosedPoint.toFunctionField` at the old L408. Its body
  remains a typed `sorry` (unchanged).

### File: `AlgebraicJacobian/RiemannRoch/OcOfD.lean`

- **What**: `sheafOf_singlePoint` at L189 calls
  `lineBundleAtClosedPoint (C := C) P hP hPcoh`. After the
  instance-add on `lineBundleAtClosedPoint`, this call needs
  `[IsLocallyNoetherian C.left]` and
  `[Scheme.IsRegularInCodimensionOne C.left]` in scope. The file's
  top-level `variable` block at L86-89 does NOT include them, so I
  added them inline to `sheafOf_singlePoint`'s own signature (other
  declarations in this file don't reference `lineBundleAtClosedPoint`
  and remain unchanged).
- **Why**: required cascade-fix for downstream compilation. No body
  change; the existing typed `sorry` in `sheafOf_singlePoint` is
  preserved.
- **Cascading**: only `sheafOf_singlePoint`; `sheafOf`,
  `sheafOf_zero`, and `sheafOf_ses_single_add` do NOT call
  `lineBundleAtClosedPoint` and need no changes.

## New Sorries Introduced

- `AlgebraicJacobian/RiemannRoch/OCofP.lean:428` — sorry inside
  `lineBundleAtClosedPoint.carrierPresheaf_isSheaf`. After the
  `Presheaf.isSheaf_iff_isSheaf_forget` reduction, the goal is the
  `Type`-valued sheaf condition for the forget of `carrierPresheaf`
  (per-open `U ↦ ↥(carrierSubmodule P hPcoh U)`, a sub-Type-presheaf
  of `K(C)`). The standard argument: `IsIntegral C.left ⟹
  IrreducibleSpace C.left.toTopCat` forces matching families on a
  cover to all be the same `f ∈ K(C)`; the per-`Q` order condition
  on `U` then follows because every `Q ∈ U` lies in some cover
  element `Vᵢ`. ~30-50 LOC of explicit `Presheaf.IsSheaf`-arithmetic,
  deferred to the iter-187 prover round.

## Pre-existing Sorries Closed

- `AlgebraicJacobian/RiemannRoch/OCofP.lean` (old L397) —
  `lineBundleAtClosedPoint` body. Replaced from `sorry` to
  `⟨carrierPresheaf P hPcoh, carrierPresheaf_isSheaf P hPcoh⟩`. This
  meets the iter-187 progress-critic HARD BAR.

## Net sorry delta

- Pre-existing typed sorries before refactor: **7**
  (`lineBundleAtClosedPoint` L397, `toFunctionField` L418,
  `globalSections_iff_mp` L480, `globalSections_iff_mpr` L526,
  `h1_vanishing_genusZero` L624, `dim_eq_two_of_genusZero` L661,
  `exists_nonconstant_genusZero` L719).
- Pre-existing typed sorries closed by this refactor: **1**
  (L397 `lineBundleAtClosedPoint`).
- New typed sorries opened by this refactor: **1**
  (the `carrierPresheaf_isSheaf` body sorry).
- **Net sorry delta: 0** (within the directive's "0 net or +1 net
  acceptable" allowance).

The 7-sorry count is now structurally different from the pre-iter-187
state: the load-bearing structural sorry on `lineBundleAtClosedPoint`'s
body is gone, replaced by a narrow named typed sorry that is one
forget-reduction away from a `Type`-valued sheaf condition on a
sub-presheaf of the constant `K(C)`-sheaf — a much smaller, much more
attackable target.

## Compilation Status

- `AlgebraicJacobian/RiemannRoch/OCofP.lean`: **compiles** (7 sorry
  warnings; no errors).
- `AlgebraicJacobian/RiemannRoch/OcOfD.lean`: **compiles** (4 sorry
  warnings + 1 pre-existing `open scoped Classical` style warning;
  no errors).
- `lake build AlgebraicJacobian`: **GREEN** (8358/8358 jobs).
- `lean_verify` on `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierPresheaf`:
  axioms = `[propext, Classical.choice, Quot.sound]` — axiom-clean
  modulo standard Mathlib axioms.
- `lean_verify` on `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint`:
  axioms = `[propext, sorryAx, Classical.choice, Quot.sound]` —
  `sorryAx` flows in via `carrierPresheaf_isSheaf` (expected per the
  one-narrow-sorry allowance).

## Notes for Plan Agent

- **The substantive Step-5 closure is `lineBundleAtClosedPoint`'s
  body, not the sheaf-property body.** The pre-iter-187
  progress-critic verdict (CHURNING, 7 flat sorries) was driven by
  the L397 structural sorry. That sorry IS NOW CLOSED in the
  `noncomputable def lineBundleAtClosedPoint`. The remaining narrow
  sorry inside `carrierPresheaf_isSheaf` is a CONCRETE Type-valued
  sheaf-condition body, not a structural blocker — every downstream
  pre-existing sorry can now access `lineBundleAtClosedPoint`'s
  explicit `carrierPresheaf`-based unfolding via the new private
  declarations.

- **Cascade-attack opportunity for the iter-187 prover round.** The
  4 downstream pre-existing sorries gated on the L397 body shape are
  now unblocked at the typecheck level:
  - `toFunctionField` (L480 after edit) — body is the `K(C)`-image
    of a global section; with `carrierPresheaf` available, the
    section unfolds to a `↥(carrierSubmodule P hPcoh ⊤)`, whose
    `.1` is the element of `K(C)`.
  - `globalSections_iff_mp` (L536) — forward direction; with
    `carrierSubmodule` membership accessible via the new
    `carrierPresheaf.obj` unfolding, the construction of `s` from
    `f` becomes an explicit `⟨f, hf_in_carrier⟩`.
  - `globalSections_iff_mpr` (L581) — reverse direction; the order
    conditions on `f := toFunctionField s` follow from the
    membership `s.1 ∈ carrierSubmodule P hPcoh ⊤` by definition
    of `carrierSet`.
  - `h1_vanishing_genusZero` (L691) / `dim_eq_two_of_genusZero`
    (L728) — both stay blocked on the χ-additive + SES chain in
    `OcOfD.lean` / `RRFormula.lean` (NOT on
    `lineBundleAtClosedPoint`'s body shape).
  - `exists_nonconstant_genusZero` (L782) — gated on
    `dim_eq_two_of_genusZero` + `globalSections_iff` chain.

- **The narrow `carrierPresheaf_isSheaf` sorry has a specific shape**
  that the iter-187 prover round can attack with these tactics:
  - After `rw [Presheaf.isSheaf_iff_isSheaf_forget _ _
    (CategoryTheory.forget (ModuleCat.{u} kbar))]`, unfold to the
    type-valued sheaf condition explicitly via
    `Presheaf.isSheaf_iff_isSheafEqualizer` or
    `Presheaf.IsSheaf.of_isSheafFor_arrows` (the project's `Opens`
    sites idiom).
  - The argument *should* factor through a "subpresheaf of the
    constant `K(C)` sheaf" Mathlib idiom; the iter-187 prover round
    may want to check `CategoryTheory.Subpresheaf` (Type-valued, so
    after the forget) for the right inheritance lemma.
  - The constant `K(C)` presheaf is a sheaf on irreducible spaces
    via `Presheaf.isSheaf_constant` or
    `IrreducibleSpace`-restricted sheafiness lemmas — worth
    checking the exact Mathlib spelling.

- **No protected-signature concerns.** `archon-protected.yaml` lists
  only `AlgebraicGeometry.genus`, `Jacobian`-namespace declarations,
  and `AbelJacobi` declarations. The `lineBundleAtClosedPoint` and
  `toFunctionField` signature amendments (instance-arg additions
  only — backward-compatible at call sites in scope) do NOT touch
  any protected declaration.

- **No blueprint changes made.** The new declarations
  (`carrierPresheaf`, `carrierPresheaf_isSheaf`) are private and not
  visible in the blueprint; `\lean{...}` markers in
  `RiemannRoch_OCofP.tex` already point at the existing pinned
  declarations whose signatures are unchanged (modulo the
  instance-arg additions, which the blueprint doesn't pin
  individually). The plan agent may wish to add an informal
  paragraph to the chapter noting that the body of
  `lineBundleAtClosedPoint` now lives via the `carrierPresheaf` +
  `carrierPresheaf_isSheaf` chain.

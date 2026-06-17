# Refactor Directive

## Slug
m1-excise-iter126

## Problem

The M1 bridge declaration `relativeDifferentialsPresheaf_equiv_kaehler_appLE`
in `AlgebraicJacobian/Differentials.lean` plus its load-bearing
sub-lemma `IsAffineOpen.appLE_isLocalization` together host one
project sorry (`Function.Bijective ⇑forwardAlg` at L398 inside the
`AlgEquiv.ofBijective forwardAlg sorry` packaging). The iter-125
strategy-critic + iter-126 strategy-critic both confirmed:

- The bridge has **zero in-tree consumers** (verified iter-125 grep:
  the bridge declaration is referenced only by its own declaration
  line + one comment in `Differentials.lean`; no other `.lean` file
  uses it).
- The extractable Mathlib-PR candidate is **M1.d**
  (`kaehler_quotient_localization_iso` — generalises
  `tensorKaehlerEquivOfFormallyEtale` to the "only base is unramified"
  case) and is **already closed in body** with no sorry. It can ship
  as an upstream Mathlib PR independently of the bridge.
- M1.b (`appLE_isLocalization`) is "too scheme-morphism-shaped for
  upstream PR and remains a project-local lemma" — closing it produces
  neither a downstream consumer NOR a Mathlib PR.

Under the iter-121 user pivot ("zero inline sorry") + iter-126 user
hint ("no good reason to … not do the work; ~6500–9000 LOC may not be
that much for an AI", "find the shortest path" qualified by "your role
is to fill mathlib gaps"), the iter-126 strategy-critic ratified that:

- Excising the bridge IS the shortest path among legitimate work
  options: zero in-tree consumer cost + drops project sorry count by
  1.
- "Filling a Mathlib gap" is satisfied by M1.d (already in tree and
  PR-able); excising the bridge does NOT remove that contribution.

The iter-128 hard trigger committed iter-125 says "indefinite parking
is not an option"; iter-126 brings this forward. The plan-agent
commits to excise THIS iter rather than defer to iter-128 (which
would be a "decision iter" with no new evidence between now and
then — sunk-cost-adjacent per iter-126 critic).

## Mathematical Justification

The bridge declaration
`AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`
asserts that on each affine chart `V ⊆ f⁻¹U` with `U`, `V` affine,
the section module of the relative cotangent presheaf is
`Γ(X,V)`-linearly isomorphic to the appLE-algebra Kähler module. It
relies on the sub-lemma
`AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (asserting the
inverse-image presheaf colimit ring at `V` is the localization of
`Γ(S,U)` at the `appLE_unitSubmonoid`).

These declarations were introduced iter-121 with the speculative
intent of bridging the presheaf form to the algebra form. The actual
downstream consumer of the FORWARD direction (smoothness criterion)
is `smooth_locally_free_omega`, which **closed iter-120 in
algebra-Kähler form WITHOUT the bridge**. The bridge is therefore
unconsumed in-tree, and its M1.b sub-lemma's body residual
(`Function.Bijective ⇑forwardAlg`) is a project-local sorry whose
closure has no downstream effect.

The off-loop M1 PR candidate (M1.d `kaehler_quotient_localization_iso`)
remains in the tree post-excise as a standalone utility, retaining
the project's upstream-Mathlib-contribution path. The detailed
design + closure recipe lives in
`analogies/relative-differentials-presheaf-bridge.md`.

## Changes Requested

### File: `AlgebraicJacobian/Differentials.lean`

Delete the following 7 declarations (in order of appearance), all
inside the `namespace AlgebraicGeometry.IsAffineOpen` block (which
spans L70–L400) and one declaration at L463–L522 inside the
subsequent `namespace AlgebraicGeometry.Scheme` block:

1. **`appLE_unitSubmonoid`** (L78–L88) — M1.b setup, the multiplicative
   subset of `Γ(S,U)` whose `appLE`-images are units in `Γ(X,V)`.
2. **`appLE_colimRingHom`** (L90–L102) — M1.b setup, the cocone-leg
   ring map `Γ(S,U) → A_colim` from the pullback/pushforward unit.
3. **`appLE_colimAlgebra`** (L104–L110) — M1.b setup, the algebra
   structure transported from the cocone-leg ring map.
4. **`appLE_colimRingHom_comp_φV`** (L112–L150) — M1.b setup,
   composition compatibility lemma.
5. **`isUnit_appLE_unitSubmonoid_in_colim`** (L152–L267) — M1.b Step 0
   (each element of the unit-submonoid is a unit in `A_colim`).
6. **`appLE_isLocalization`** (L269–L398) — M1.b residual carrier
   (HAS THE SORRY at L398; the entire 130-line declaration is
   removed).
7. **`relativeDifferentialsPresheaf_equiv_kaehler_appLE`** (L449–L522)
   — the bridge itself (in `namespace AlgebraicGeometry.Scheme`),
   which depends on the M1.b sub-lemma above.

**Keep** the following declarations (unchanged):

- `relativeDifferentialsPresheaf` (L41–L54) — presheaf definition,
  independently useful.
- `relativeDifferentialsPresheaf_obj_kaehler` (L56–L66) — rfl
  identification lemma.
- `kaehler_localization_subsingleton` (L406–L414) — standalone utility
  (consumed by `kaehler_quotient_localization_iso`).
- `kaehler_quotient_localization_iso` (L416–L447) — **M1.d
  Mathlib-PR candidate**; standalone utility (uses
  `kaehler_localization_subsingleton`, NOT consumed by the bridge).
- `smooth_locally_free_omega` (L524–L572) — forward-direction
  smoothness criterion, independent of the bridge.

Also drop the namespace `namespace AlgebraicGeometry.IsAffineOpen` /
`end AlgebraicGeometry.IsAffineOpen` wrapper if it's now empty (all 6
declarations inside it are excised).

Update the file-level docstring (L15–L29) and any other in-file
comments to remove references to the excised declarations. Specifically:
- L28 references "Blueprint: `blueprint/src/chapters/Differentials.tex`."
  Keep this.
- Any comment line referencing `appLE_isLocalization`,
  `appLE_unitSubmonoid`, `appLE_colimRingHom`, etc. should be removed
  or rewritten.

### File: `blueprint/src/chapters/Differentials.tex`

The plan agent will update the blueprint chapter SEPARATELY (the
refactor agent must NOT edit blueprint chapters per the refactor
descriptor rules). Document in your report which blueprint references
to the excised declarations remain so the plan agent can address
them.

### File: `AlgebraicJacobian.lean` (umbrella)

If `AlgebraicJacobian.lean` has explicit imports per module, no edit
is needed (we're not removing the module, just declarations inside
it).

## Affected Files

- `AlgebraicJacobian/Differentials.lean` — primary file (deletions
  only).
- No other Lean file should require modification; the excised
  declarations have **zero in-tree consumers** (verified iter-125 grep).
  Confirm this independently with:
  `Grep -r 'appLE_isLocalization\|relativeDifferentialsPresheaf_equiv_kaehler_appLE\|appLE_unitSubmonoid\|appLE_colimRingHom\|appLE_colimAlgebra\|isUnit_appLE_unitSubmonoid_in_colim' AlgebraicJacobian/`
  Should return only matches inside `Differentials.lean` itself
  (declaration sites + internal references inside the bodies being
  excised).

## Expected Outcome

After the refactor:

- Project sorry count: 2 → 1 (the M1.b sorry at the old
  Differentials.lean:398 is excised). Remaining sorry:
  `Jacobian.lean:179` `nonempty_jacobianWitness` (OFF-LIMITS).
- `AlgebraicJacobian/Differentials.lean` compiles cleanly with kernel-
  only axioms (`propext, Classical.choice, Quot.sound`) for ALL
  remaining declarations.
- Net LOC reduction: ~300 LOC removed from `Differentials.lean`.
- `relativeDifferentialsPresheaf` + its rfl lemma + the M1.d
  `kaehler_quotient_localization_iso` (the Mathlib-PR candidate) all
  remain in the tree.
- `lean_verify` on `AlgebraicGeometry.Scheme.smooth_locally_free_omega`
  still returns `[propext, Classical.choice, Quot.sound]` (unchanged).
- `lean_verify` on `AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso`
  still returns kernel-only axioms.

Verify: `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" AlgebraicJacobian/ --format=summary`
should report 2 total sorries after this refactor + the parallel
M2.a scaffold refactor:
- 1 in `Jacobian.lean:179` (`nonempty_jacobianWitness`, OFF-LIMITS).
- 1 in `RigidityKbar.lean` (`rigidity_over_kbar`, NEW scaffold from
  the parallel refactor).

Net cross-refactor sorry change: 2 → 2 (M1 -1, M2.a +1). The
qualitative change is the substitution of a parked-dead-weight sorry
with an active-critical-path sorry.

`archon-protected.yaml` is unchanged (none of the excised
declarations are protected).

## Notes for Plan Agent

- The grep verification step: the iter-125 plan-agent verified zero
  in-tree consumers, but please confirm via the Grep command above
  before committing the deletion. If the grep returns matches outside
  `Differentials.lean`, document them and STOP — the deletion is no
  longer free.
- The M1.d declaration `kaehler_quotient_localization_iso` remains
  standalone as the Mathlib-PR candidate. The plan agent's
  `analogies/relative-differentials-presheaf-bridge.md` file already
  documents this contribution path; the iter-127+ off-loop PR work
  can proceed from there.
- The plan agent will update `blueprint/src/chapters/Differentials.tex`
  to reflect the excision (drop `\rem:m1_parked_iter125` since M1 is
  no longer parked, drop references to the excised declarations). Do
  NOT edit the blueprint yourself.
- If you find that any of the "Keep" declarations actually depends on
  one of the "Delete" declarations (e.g. transitively through a
  helper), document this and STOP. The plan agent will re-scope the
  deletion.

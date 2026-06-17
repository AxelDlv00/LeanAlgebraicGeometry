# Session 243 (iter-243) — review

## Metadata
- **Iter / session:** 243.
- **Prover lanes:** 2 — `Picard/TensorObjSubstrate.lean` (mathlib-build, Lane 1, A.1.c critical path)
  and `Cohomology/FlatBaseChange.lean` (Lane 2, engine / affine close).
- **Sorry counts (per file, unchanged):** TensorObjSubstrate 2→2 (L715 `exists_tensorObj_inverse`,
  L1269 `addCommGroup_via_tensorObj` — both pre-existing deferred, off-limits this iter);
  FlatBaseChange 2→2 (L742 `affineBaseChange_pushforward_iso`, L764 `flatBaseChange_pushforward_isIso`).
- **Canonical critical-path counter: flat** (no pre-existing canonical sorry eliminated).
- **Build:** GREEN both files (deprecation `Sheaf.val` + long-line warnings only).
- **Axioms:** `pullbackTensorMap` re-verified first-hand → `{propext, Classical.choice, Quot.sound}`
  (the `lean_verify` "opaque" flag at L488 is the word inside a prose comment — not laundering).
- **sync_leanok:** iter 243, sha `ca65ebef`, **+3 / −0** on `Picard_TensorObjSubstrate.tex`.

## Headline
The **"Lane 1 lands its PRIMARY δ_sheaf comparison map axiom-clean and pins the route's two hard
blockers precisely; Lane 2 confirms BOTH affine-close obligations Mathlib-scale and trips the
documented #37189-bump watch-signal"** iter. One genuine new axiom-clean theorem
(`pullbackTensorMap`) on the critical path, plus a verified-precise handoff on each of the four
remaining route obligations. No canonical sorry dropped — but neither prover churned, neither pinned
a sorry, and both reduced their open problem to one sharply-named obstacle with a concrete next move.

## Lane 1 — `Picard/TensorObjSubstrate.lean` (mathlib-build)

### `pullbackTensorMap` (= δ_sheaf, `lem:pullback_tensor_map`) — SOLVED, axiom-clean
The sheaf-level comparison MORPHISM `f^*(M ⊗_X N) ⟶ f^*M ⊗_Y f^*N` for **general** `M, N`, a 4-step
composite (3 isos + the one genuine map `a_Y.map δ`):
1. `(sheafificationCompPullback φ).app (M.val ⊗ₚ N.val)).hom` — moves abstract pullback inside
   sheafification (`φ = f.toRingCatSheafHom`).
2. `a_Y.map (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') M.val N.val)` — the presheaf
   oplax comparison (`presheafPullbackOplaxMonoidal`, landed iter-242), sheafified.
3. `(sheafifyTensorUnitIso ...).hom` — reconciles `a_Y(P ⊗ₚ Q)` with `a_Y((a_Y P).val ⊗ₚ (a_Y Q).val)`.
4. `a_Y.map (tensorHom (forget.map (pullbackValIso f M).hom) (forget.map (pullbackValIso f N).hom))`.

**KEY GOTCHA (the unlock):** `Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ.hom) …` fails
with "typeclass instance problem is stuck" — the `MonoidalCategory` instances on the source/target
presheaf categories are keyed on the *CommRingCat* `forget₂`-form while `φ.hom` presents the RingCat
form. **Fix = the `φ'` let-coercion** (mirroring iter-242's `presheafPushforwardLaxMonoidal`):
```lean
let φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
    (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) := φ.hom
```
Then `PresheafOfModules.pullback φ'` finds `OplaxMonoidal` and the δ accessor elaborates; the
`≫`-composition bridges `φ.hom ≟ φ'` and `⊗ₚ ≟ ⊗` by defeq with no manual `change`. Succeeded first try.

### `pullbackValIso` (helper) — SOLVED, axiom-clean, unpinned
`a_Y((pullback φ.hom).obj M.val) ≅ (pullback f).obj M`, from
`(sheafificationCompPullback φ).symm.app M.val ≪≫ (pullback f).mapIso (counit_X.app M)` — the
`tensorObj_unit_iso` reflective-counit idiom. Used in step 4 above.

### `IsInvertible.isLocallyTrivial` (deliverable 2, `lem:isinvertible_implies_locallytrivial`) — BLOCKED, Mathlib-scale
Two scheme-level ingredients absent at the pin:
1. **Stalk-invertibility plumbing** — no in-tree bridge `(sheaf iso M⊗N≅𝒪_X) ⇒
   Module.Invertible 𝒪_{X,x} (M.val.stalk x)`; needs stalk-of-sheafification at the PresheafOfModules
   level + the d.2 `stalkTensorIso` + `𝒪_X.val.stalk x ≅ 𝒪_{X,x}` + deriving the `Module.Invertible`
   instance. ~150 LOC, no single lemma.
2. **Finite-presentation spreading-out for SheafOfModules on a scheme** (hard blocker) — "M f.p. +
   M_x free ⇒ M≅𝒪 on an affine nbhd", present in Mathlib only at the CommRing/LocalizedModule level;
   moreover M's finite presentation itself is not part of the SheafOfModules data and must first be
   derived from invertibility (needs QC/finite-type infrastructure the bare carrier lacks).

Algebra pieces that DO exist (scouted): `Module.Invertible.free_iff_linearEquiv`,
`CommRing.Pic.mk_eq_one_iff_free`, `CommRing.Pic.instSubsingletonOfIsLocalRing`,
`Module.FinitePresentation.exists_free_localizedModule_powers`, `Module.free_of_isLocalizedModule`.
Prover correctly did NOT write the ~150-LOC stalk fragment (reaches no pin, leaves blocker 2 intact)
and pinned no sorry.

### `IsInvertible.pullback` (deliverable 3, `lem:isinvertible_pullback`) — BLOCKED on deliverable 2
Assembly fully scoped — witness `f^*N`, iso `(asIso δ_sheaf).symm ≫ (pullback f).mapIso e ≫
pullbackUnitIso`; all other inputs in-tree (`pullbackTensorMap` this iter, `pullbackUnitIso`,
`tensorObj_isLocallyTrivial`, `isIso_of_isIso_restrict`, `LineBundle.IsLocallyTrivial.pullback`).
Gated only on the trivialising cover from deliverable 2. Remaining crux once 2 lands: the
"δ_sheaf restricts to the canonical 𝒪⊗𝒪≅𝒪" compatibility, discharged on the cover (NOT stalkwise).

## Lane 2 — `Cohomology/FlatBaseChange.lean`

### `affineBaseChange_pushforward_iso` obligations — BOTH BLOCKED, Mathlib-scale
- **Aux brick `pushforwardBaseChangeMap_naturality` (ATTEMPTED, removed, no sorry):** built to the
  final naturality square. Both `← Adjunction.homEquiv_naturality_left/right_symm` fired; unit step
  closed via `← Functor.map_comp_assoc` + `(pullbackPushforwardAdjunction g').unit.naturality η`
  (`show…from…` bridged the `(𝟭).map η = η` defeq); `erw [Functor.map_comp_assoc]` split the
  unit-composite (plain `rw` SILENTLY FAILS). **WALL:** the three component naturalities
  (`pushforwardComp.hom.naturality_assoc`, `pushforwardCongr.hom.naturality_assoc`,
  `pushforwardComp.inv.naturality`) cannot be applied — plain `rw` "did not find an occurrence of the
  pattern" (functor `.map`-of-composite is defeq-not-syntactic for SheafOfModules functors); `erw`
  whnf-explodes (`timeout at whnf, 200000 heartbeats`). Section-wise dodge (`ext U`+`simp`) reaches a
  clean section goal but `pushforwardComp_*_app_app = id` still won't rewrite (same defeq-display
  wall; `simp` "unused", `rw` no-match; `aesop_cat` stalls). And this brick is naturality-in-`F`,
  whereas obligation 1 needs naturality-in-the-square — so its downstream value is marginal anyway.
- **Obligation 1 `base_change_map_affine_local`** — restriction-of-the-square compatibility of the
  mate (`.app U` over affine `U ⊆ S'` = bcm of the restricted square). Mathlib packages neither this
  nor a "base change of a base-change map" lemma; rests on exactly the naturality machinery that hit
  the defeq wall.
- **Obligation 2 `pushforward_base_change_mate_cancelBaseChange`** — identify the bespoke
  `pushforwardBaseChangeMap` (built from `pushforwardComp`/`pushforwardCongr` pseudofunctor
  coherences, NOT `mateEquiv`) with `tilde(cancelBaseChange)`. Mathlib HAS the mate calculus
  (`mateEquiv`, `conjugateEquiv`, `Adjunction.Mates`) and the closing algebra (`cancelBaseChange`,
  no flatness) but the bridge is the genuine multi-hundred-LOC unwind. The concrete-iso wrapper was
  assessed and DROPPED: `cancelBaseChange`'s orientation `M⊗[A](A⊗[R]N)≃[B]M⊗[R]N` does not directly
  orient to the blueprint's `(R'⊗_R A)⊗_A M≃[R']R'⊗_R M` (in the affine setup `R'` is not an
  `A`-module; correct labeling depends on objects that only exist once the affine reduction is built)
  — a standalone wrapper would guess wrong objects.

**WATCH-SIGNAL TRIGGERED (progress-critic ts243):** both obligations come back blocked with no
in-tree reduction → the documented next move is the **#37189 Mathlib bump**
(`isIso_fromTildeΓ_pushforward`), NOT another in-tree round.

## Environment note
- **Informal agent UNAVAILABLE.** `MOONSHOT_API_KEY` set but returns `401 Invalid Authentication`
  (as documented since iter-234/237); no other provider key set. No second opinion obtainable.

## Blueprint doctor
CLEAN — every chapter `\input`'d, every `\ref`/`\uses` resolves, no `axiom` declarations.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:isinvertible_implies_locallytrivial`: added `% NOTE:`
  recording the iter-243 confirmation that the block is Mathlib-scale (two precise absent
  ingredients) and is NOT formalized (no decl, no sorry).
- No `\mathlibok` added (no decl is a pure Mathlib re-export/alias).
- No `\lean{...}` renames flagged by the provers.
- No stale `\notready` to strip.
- `\leanok` for `lem:pullback_tensor_map` was added by the deterministic `sync_leanok` (not me).

## Recommendations for next plan
See `recommendations.md`. Headline: Lane 1's critical path is now route-blocked behind a confirmed
Mathlib-scale construction (deliverable 2); the productive next moves are a dedicated mathlib-build
sub-lane for finite-presentation spread-out OR a Mathlib bump. Lane 2 should switch to the #37189 bump
— do NOT re-dispatch an in-tree `rw`/`erw` round on the `pushforwardComp` `.map`-of-composite terms.

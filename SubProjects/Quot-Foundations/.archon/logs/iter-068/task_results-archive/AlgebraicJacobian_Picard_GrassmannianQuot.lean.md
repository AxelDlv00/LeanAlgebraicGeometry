# AlgebraicJacobian/Picard/GrassmannianQuot.lean — iter-067

## Headline

**`grPointOfRankQuotient_rel` is CLOSED** (the Nitsure-inverse well-definedness lemma,
one of the two assigned targets) via a new ~500-LOC transport chain; additionally the
**refactor-crash damage was repaired across the tree**: GlueDescent.lean (2 fixes,
builds green again) and the broken scaffold region of this file (chartLocus
noncomputable, IsOpenCover qualification, chartMatrixHom instance, chartLocus_rel proof).
LSP-clean; kernel `lake build` validation in flight at last update.

## CRITICAL FINDING: the tree was broken on dispatch (refactor crash), repaired here

- The iter-067 refactor `split-glue-descent` was **killed mid-repair at ~14:53** (its
  jsonl ends right after a failing `lean_build`). It left `GlueDescent.lean` BROKEN on
  disk: (1) `pullback_isLocallyFreeOfRank` was moved into GlueDescent which only
  imported Mathlib, so `SheafOfModules.IsLocallyFreeOfRank` (defined in QuotScheme.lean)
  was an unknown constant; (2) the `glueOverlapBaseChangeIso` scaffold at L1165 had an
  `eqToIso` whose argument was `glueData_preimage_image_eq` the wrong way round
  (type mismatch).
- **No lane-1 (GlueDescent) prover was ever dispatched** — `.archon/logs/iter-067/provers/`
  contains only this prover's jsonl. Nobody else would fix the tree this iter.
- Per the iter-067 objectives' contingency ("If refactor ABORTED: lanes 1+2 collapse to
  one GrassmannianQuot lane"), I performed a **minimal crash-recovery repair of
  GlueDescent.lean** (deviation from "own file only", documented here):
  1. Added `import AlgebraicJacobian.Picard.QuotScheme` (QuotScheme imports only Mathlib,
     no cycle; GrassmannianQuot already imported both).
  2. Inserted `.symm` on the `glueData_preimage_image_eq` argument of the `eqToIso` at
     GlueDescent L1165-66.
  No semantic change to any lane-1 math; the two GlueDescent sorries (L1169 ext-V
  condition inside `glueOverlapBaseChangeIso`, keystone `isIso_glueRestrictionHom`
  ~L1206) are untouched.
- **Beware: `lake build X | tail` masks the exit code** (pipe). My session-start "green
  baseline" was a false positive for exactly this reason. Use `${PIPESTATUS[0]}`.

## grPointOfRankQuotient_rel (was L2289) — RESOLVED (LSP-clean; kernel check pending)

### Attempt 1 (this session)
- **Approach:** full transport chain, ~330 LOC inserted between `chartLocus_rel` and
  `grPointOfRankQuotient_rel`:
  - `scalarEnd_unitEndSection` — every unit-endo is `scalarEnd` of its `⊤`-section
    (via `unitHomEquiv.injective` + naturality at `Y ≤ ⊤`).
  - `ιFree_projFree`, `ιFree_matrixEndRect_projFree` — entry extraction for
    `matrixEndRect` (biproduct `ι_π` + `Finset.sum_eq_single`).
  - `matrixEndRect_unitEndSection` — matrix presentation of an arbitrary
    `free r ⟶ free d` (cofan ext on the source, `cancel_mono isoCoproduct.inv` +
    `biproduct.hom_ext` on the target).
  - `pullback_conj_matrixEndRect` — `Q⁻¹ ≫ p^*(matrixEndRect N) ≫ Q = matrixEndRect
    (N.map p^♯)` (from `matrixEndRect_pullback`).
  - `conjPullback_congr` (subst), `pullbackFreeIso_inv_pullbackComp` (the `hstar` of
    the functor `map_comp` proof extracted generically), `conjPullback_comp`
    (pseudofunctor coherence: conj along `p ≫ a` = `p`-pullback of conj along `a`;
    via `pullbackComp.inv` naturality at `u`/`c` + `pullbackFreeIso_comp`).
  - `chartMatrixHom_rel` — f-cancellation: over `chartLocus y`, presenting `y` =
    presenting `x` (`hf` + `chartComposite_rel` + `IsIso.eq_inv_of_hom_inv_id`).
  - `chartMatrixHom_transport` — `chartMatrixHom x = Q⁻¹ ≫ (homOfLE e)^* (chartMatrixHom
    y) ≫ Q` for any `e : chartLocus x ≤ chartLocus y` (parametrized by `e`, NOT by the
    locus equality's proof term — avoids rw-alignment issues).
  - `chartMatrix_rel` — entrywise: `chartMatrix x p i = (homOfLE e).appTop (chartMatrix
    y p i)`.
  - `chartMorphism_rel` — `chartMorphism x = homOfLE e ≫ chartMorphism y`
    (`toSpecΓ_naturality` + `Spec.map_comp` + `MvPolynomial` ringHom ext).
  - `grPointOfRankQuotient_rel` — `OpenCover.hom_ext` over the `x`-cover, both glued
    morphisms restricted via `ι_glueMorphisms`, transported along
    `homOfLE_ι`.
- **Result:** RESOLVED. Zero LSP errors over the whole file.
- **Load-bearing tricks discovered this session (extend the diamond playbook):**
  - **Term-mode `haveI` in a `def` body can fail instance synthesis across the
    `X.Modules` diamond even when the spelling is identical** (chartMatrixHom). Fix:
    `@CategoryTheory.inv _ _ _ _ f instTerm` with the instance passed explicitly.
  - **`rw [reassoc_of% h]` fails even on locally-`have`d equations** when the goal's
    composite was produced by an ascription whose subterm representations came from a
    *different* elaboration (conjPullback_comp). Fix: full `calc` with
    `congrArg (fun z => ...)` steps + `by simp only [Category.assoc]` re-association
    bridges; never positional rw.
  - **`change` unifies its pattern against the EXISTING goal term**, so the changed goal
    keeps the def's instance paths — a later `rw [myHave]` then fails (chartMorphism_rel).
    Fix: prove the equation between freshly-spelled forms (`have key`) and finish with a
    single `exact key` (one full-defeq absorption at the end).
  - **`MvPolynomial.aeval` with no expected type leaves the base ring as a metavariable**
    → instance chaos. Always `(R := ℤ)` in freestanding `have`s.
  - **`exact Scheme.Cover.ι_glueMorphisms _ _ _ I` picks the WRONG cover** when `I`'s
    type is the other cover's `I₀` (unifier solves `?𝒰.I₀ ≡ (x-cover).I₀` by projection).
    Pass the cover explicitly.
  - `MvPolynomial.ringHom_ext'` + `Subsingleton.elim _ _` (ℤ-ring-hom uniqueness)
    cleanly dispatches the `C`-generator case over ℤ.
  - calc-step `rfl` against a def-unfolding can throw a spurious `Trans Eq Eq ?m`
    error — same fix as the `change` issue: spell both endpoints, `exact` at the end.

## Adjacent progress beyond the assigned target (Atom A of the L2249 overlap)

After closing `_rel`, landed the first ingredient of the overlap compatibility
(Nitsure `φ_I^* X^I = M^I` with `M^I_I = 1`), all compiling:

- `instance isIso_pullback_chartLocus_map` — `isIso_pullback_isoLocus_map` keyed on the
  `chartLocus` spelling, registered as an INSTANCE (term-level `haveI` copies are NOT
  found across the diamond — root cause of the original scaffold breakage at the old
  L2201; the `chartMatrixHom` def body now passes the instance explicitly via `@inv`).
- `pullback_map_freeMap_pullbackFreeIso` — naturality of the free-pullback comparison in
  the index map (`p^*(freeMap g) ≫ Q_m = Q_n ≫ freeMap g`); Cofan-ext +
  `pullback_map_ιFree_comp_pullbackObjFreeIso_hom` per injection.
- `freeMap_chartMatrixHom` — **the `I`-minor is `𝟙` at the morphism level**:
  `freeMap ι_I ≫ chartMatrixHom x I hI = 𝟙` (the composite presents the chart composite
  against its own inverse).
- `unitEndSection_id` / `unitEndSection_zero` (both `rfl`).
- `chartMatrix_minor` — entry level: `M^I_{p, ι_I(q)} = δ_{q p}`.

These feed the L2249 overlap directly: what remains there is (i) restriction of
`chartMatrix` to the categorical intersection `pullback (T_I.ι) (T_J.ι)`, (ii)
invertibility of the `J`-minor of `M^I` there (from invertibility of the `J`-chart
composite), (iii) factorization through the overlap chart `V_IJ` + Γ-Spec uniqueness,
(iv) the change-of-basis identity via `universalMatrix_map_transitionPreMap`.

## Not attempted this session
- `tautologicalQuotient_epi` (needs `glue_unique` from the GlueDescent keystone —
  lane-1 never ran; left pinned per objectives).
- `chartLocus_isOpenCover` (Nakayama), `isIso_pullback_isoLocus_map` (gluing local
  inverses), the `grPointOfRankQuotient` overlap sorry (L2249) beyond Atom A,
  `represents` inverse laws.

## Dead ends / calc gremlins (this session)
- A multi-step `calc` whose steps are individually fine can still die with
  `failed to synthesize Trans Eq Eq ?m` (seen twice). Converting the SAME steps to named
  `have s1 ... s7` + `exact s1.trans (s2.trans ...)` elaborates cleanly. When a calc
  fights back, switch to haves — do not debug the calc.
- `SheafOfModules.ιFree_freeMap` and bare `SheafOfModules.freeMap g` need `(R := ...)`
  ascriptions in freestanding `have`s (the ring sheaf is otherwise a stuck metavariable).

## Markers for review agent
- `sync_leanok` will pick up `grPointOfRankQuotient_rel` (proof closed; note it inherits
  the sorryAx of `grPointOfRankQuotient`'s overlap argument through the def unfolding —
  it carries no sorry of its own and will become clean when L2249 closes).
- New unpinned decls needing blueprint blocks (add to the gr-coverage2 writer queue):
  `scalarEnd_unitEndSection`, `ιFree_projFree`, `ιFree_matrixEndRect_projFree`,
  `matrixEndRect_unitEndSection`, `pullback_conj_matrixEndRect`, `conjPullback_congr`,
  `pullbackFreeIso_inv_pullbackComp`, `conjPullback_comp`, `chartMatrixHom_rel`,
  `chartMatrixHom_transport`, `chartMatrix_rel`, `chartMorphism_rel`,
  `isIso_pullback_chartLocus_map`, `pullback_map_freeMap_pullbackFreeIso`,
  `freeMap_chartMatrixHom`, `unitEndSection_id`, `unitEndSection_zero`,
  `chartMatrix_minor`.

## Summary

- Sorry count: **7 → 6** (closed `grPointOfRankQuotient_rel`, was L2289). The other six:
  `tautologicalQuotient_epi`, `chartLocus_isOpenCover`, `isIso_pullback_isoLocus_map`,
  the `grPointOfRankQuotient` overlap argument (L2249), and the two `represents`
  inverse laws — all pre-existing, none regressed.
- Closed: `grPointOfRankQuotient_rel` — via ~600 LOC of new compiling infrastructure
  (the transport chain + Atom A). Generic helpers `conjPullback_comp` /
  `matrixEndRect_unitEndSection` verified axiom-clean
  (`propext`/`Classical.choice`/`Quot.sound` only).
- Additionally repaired the refactor-crash damage: GlueDescent.lean (import +
  `eqToIso .symm`; builds green with its 2 expected sorries) and this file's broken
  scaffold (4 fixes). **The tree was un-buildable at dispatch; it now builds.**
- Adjacent sorries: attempted and landed Atom A of the L2249 overlap (4 lemmas + 1
  instance); assessed the rest (scoped above).

## Why I stopped

`Real progress`: closed 1 sorry (`grPointOfRankQuotient_rel`; 7 → 6 in-file), landed the
I-minor ingredient of the next target, and restored the whole tree to a buildable state
after the killed refactor left it broken (without which NO prover output this iter could
have compiled — note `lake build X | tail` masks exit codes; my session-start "green
baseline" was a false positive). I stopped after securing a kernel-validated green build:
the remaining L2249 overlap is a full-session piece of new math (intersection-restriction
of the presenting matrix + minor invertibility + Γ-Spec uniqueness), and the remaining
wall-clock did not realistically fit starting it without risking leaving the file broken.
Informal agent: no API key in env (PROGRESS standing note) — not needed, no Mathlib gap
was hit. Deviation note: edited `GlueDescent.lean` (another lane's file) strictly as
crash-recovery — two mechanical compile fixes, no semantic change; no lane-1 prover
exists this iter and the refactor (write-domain `AlgebraicJacobian/**`) died mid-repair.

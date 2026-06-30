# Strategy

## Goal

Build the **comparison-isomorphism substrate on line bundles** — the A.1.c.sub work
package carved from Merten's Jacobian challenge (`references/challenge.lean.ref`). Three
seed nodes + their 108-node cone, zero inline `sorry`, kernel-only axioms:

- `lem:pullback_tensor_iso_loctriv` — `Modules.pullbackTensorIsoOfLocallyTrivial`: loc-triv comparison iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N`.
- `lem:dual_isLocallyTrivial` — `Modules.dual_isLocallyTrivial`: dual of a loc-triv module is loc-triv.
- `thm:rel_pic_addcommgroup_via_tensorobj` — `PicSharp.addCommGroup_via_tensorObj`: the `AddCommGroup` on `Pic♯_{C/k}`.

## Phases & estimations

**ACTIVE ROUTE = the dual-unit FLANK downstream cone (`TensorObjInverse.lean`).** The v4.31.0 migration
recovery is COMPLETE (089→096) AND the FLANK LEAF is CLOSED (iter-098: `PresheafDualUnitPullback.lean`
sorry-free + axiom-clean — the L1′ θ-at-unit bridge + linchpin `pushforwardBetaUnitEpsAppOne`; this was the
sole ∞-source + the genuine open math that churned 085–087). Remaining = the 4 downstream sorries in
`TensorObjInverse.lean`, which RIDE the now-frozen-green L1′ (race cleared). The pre-bump phase plan
(Cone A / Cone B dual flank / telescope) is the recipe map; detail in `## Completed` + `## Routes` + sidecars.

| Phase | Status | Iters left | Files | Risk |
|-------|--------|-----------|-------|------|
| **Dual-unit FLANK downstream cone — prover** (`TensorObjInverse.lean`) | **iter-102: keystone (a) `dual_unit_iso_restrict_assemble` CLOSED** (sorry-free, axiom-clean — RES2 via L1/L2/`adj_unit_counit_collapse`, transpose-free (†)-factorisation). Cone now = **1 sorry**: the LAST keystone obligation **(c) `trivialisation_restrict_compat`** (L2660, effort 4097), UNBLOCKED by (a). **iter-103:** effort-broke the telescope ASSEMBLY (NOT the 5 proven squares S2/S3/S4a/S4b/S4c) into a 3-link chain — Seam1 `trivialisation_restrict_eM_split` (bifunctoriality, heaviest ≈1215) + Seam2 `trivialisation_telescope_assemble` (generic `[Category]` ρ-cocycle collapse, ≈861, confines seam-crossing) + Seam3 `trivialisation_restrict_sectionwise` (≈584); effort 4097→2018. blueprint-reviewer `iter103` GATE CLEARED, progress-critic CONVERGING. **iter-103 prover:** `prove` the 3-seam chain + target, **no-grind guard** (clean sorry on the resisting seam + report; Seam1 = re-break candidate). | ~1–2 | TensorObjInverse | med: Seam2 generic `exact` confines ALL `SheafOfModules ≫` crossing (sibling of proven `c2_assemble`); Seam1 (bifunctoriality at SheafOfModules level) is the risk → re-break FINE if it resists, NOT re-prove-whole |
| Consumer seed-3 (`RelPicFunctor.lean`) | NOT regressed; rides recovered terminal `exists_tensorObj_inverse` | ~1 | RelPicFunctor.lean | — |
| Coverage + delete dead private `exists_tensorObj_inverse` dup + file-split cleanup | DEFERRED to post-FLANK | ~1–2 | tex/private | — |

## v4.31.0 Migration Recovery (ACTIVE route — pivoted iter-089)

**Trigger:** a Jun-27 toolchain bump v4.30.0-rc2 → v4.31.0 (parent branch `mathlib-bump-v4.31`) shattered
~36 fragile defeq/whnf-heavy proofs, `sorry`-isolated to reach green. The "3-sorry FLANK frontier" route
is moot — the whole engine (seed-1 K1, terminal `exists_tensorObj_inverse`, DUAL/telescope) is sorry-stubbed.

**End-state:** the same zero-sorry / kernel-only-axiom cone as before, now under v4.31.0.

**Method (forced, mechanical-ish, bottom-up):** for each regressed decl, recover the v4.30 original via
`git -C /AI4M/users/Axel/LeanAlgebraicGeometry show main:SubProjects/Line-Bundle-Comparison-Iso/<path>`
(parent `main` = clean v4.30.0-rc2; the MainProjects copy is the SAME broken state, not a source), then port
it and apply the systematic v4.31.0 fix (`restr`/`Over.map` term-forms; `appIso` ring-map direction flip;
simp normal-form drift). No new math — the blueprint/statements are unchanged and previously gate-cleared.

**Order:** DualInverse (DONE 089) → TensorObjSubstrate (DONE 090, **ROOT machinery RE-recovery DONE 093** —
13 axiom-clean decls, keystone `pushforward_mu_appIso_collapse` restored) → TensorObjInverse (green@7;
**B1 fill ACTIVE 094**, then K1+S2 file-split phase). Recovery source = parent commit
**`117100c4`** (branch `mathlib-bump-v4.31`, v4.30.0-rc2 PRE-bump, sorry-free for most decls; K1 lives in the
v4.30 ROOT L4770). Parent `main` is older/pre-split. Match by NAME, port BODY.

**ROOT machinery RE-recovery (iter-093):** iter-090's TensorObjSubstrate pass closed the 5 regressed sorries
but did NOT restore the δ/η-collapse machinery block that the v4.31 migration had DROPPED outright (the bump
re-authored the K1 region as an *incomplete* IsIso-witness route, `TensorObjSubstrate.lean:1373–1620`, so
there were no `sorry`s there to catch — the lemmas simply ceased to exist). iter-092 surfaced this when B1's
preserved v4.30 skeleton (`tensorObj_restrict_iso_eq_pullbackTensorMap`, the L818 comment) called the absent
`pushforward_mu_appIso_collapse`. The block to re-port (v4.30 `117100c4` L4077–4768, contiguous, all AFTER
`pullbackTensorMap_restrict`): `isIso_of_isIso_comp4_mid`, `pullbackTensorMap_isIso_of_base_unit`,
`pushforwardPushforwardAdj_unit/counit_app_app_apply`, `restrictScalars_oplaxMonoidal_η_app_one`,
`pushforward_eta_appIso_collapse`, `pushforward_lax_mu_comparison_rhs_tmul`/`_lhs_tmul`,
`pushforward_lax_mu_comparison`, `deltaConjOfMuComparison`, `pushforward_mu_appIso_collapse`,
`isIso_oplaxδ_of_conj`. δ-side (mu-comparison → deltaConj → mu_appIso_collapse → isIso_oplaxδ) is the priority
(unblocks B1 + K1); η-side is a bonus (closes the unit-iso flank nodes too). Blueprint entries for all of
these are INTACT (`Picard_TensorObjSubstrate.tex` L3874–4009, L7196–7238). The dead IsIso-witness scaffolding
(L1373–1620) is left in place this iter (pruned in the post-recovery cleanup) to avoid churn/breaks.

**Build discipline (HARD):** scoped `lake build <module>` only; NEVER bare `lake build`. The 12.8M-HB monster
(`presheafDualPullbackComparison_restrict`) lives UPSTREAM in `PresheafDualPullback`; with warm oleans it is
NOT re-elaborated when building TensorObjInverse. **OOM HAZARD RETIRED (iter-098): the host is now 2 TB RAM
(~1.1 TB available), not the legacy 2 GB — building `PresheafDualUnitPullback`/`PresheafDualPullback` directly
runs fine (37 s, EXIT non-137).** Consequence: the whole "PresheafDualUnitPullback OOMs → don't build it"
belief was a stale-host artifact, and that file was therefore NEVER rebuilt across the v4.31 recovery — so it
sat RED-undetected (grep saw 1 `sorry`, masking 6 elaboration errors). Trust `lake` EXIT 0 only, never LSP,
and never the grep sorry-count alone for a file imported by the monster — BUILD it.

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|-------|----------------------|-----|-------|-------------|---------------------|----------|
| DUAL dual-inverse | 015 · ~6 | ~250 | `DualInverse*.lean` | `sliceDualTransport` sorry-free; seed `dual_isLocallyTrivial` | leg-B `inv ε` rotated morphism-level (`IsIso.inv_comp_eq`), never pointwise; `maxHeartbeats 1600000` for inline `≃ₗ` | pointwise `inv ε` heartbeat-bombs; import-race green→red on shared-dep edits — isolate |
| D3′ base-change substrate | 019 · ~9 | ~600 | `TensorObjSubstrate.lean` | `pullbackTensorMap_natural`/`_restrict` cone sorry-free; substrate for seed-1 + terminal | generic `[Category C]` lemmas applied by `exact` across the SheafOfModules defeq wall; `conjugateEquiv_comp` for Sq1 | `rw/erw [Category.assoc]` whnf-bombs; top-level monoidal-carried extraction fails — keep IN-PROOF |
| D4′ seed-1 (`pullbackTensorIsoOfLocallyTrivial`) | 042 · ~24 | ~700 | `TensorObjSubstrate.lean` | `restrictScalarsMonoidalOfBijective`, `μIso`, `leftAdjointUniq` | K1 `hδ` via abstract `isIso_oplaxδ_of_conj` ← `deltaConjOfMuComparison`/`pushforward_mu_appIso_collapse` (δ-conjugation), NOT the planned `pullbackTensorMap_presheafDelta_eq` (never realized) | **LSP stale-green masked a RED root for 3 iters (039–041) — ALWAYS `lake build`, never trust LSP**; carrier diamond; whnf bombs |
| Shared keystone `conjugateEquiv_restrictFunctorComp_inv` (root) | 048 · ~5 (046–048) | ~30 | `TensorObjSubstrate.lean` | restrict-side mirror of `conjugateEquiv_pullbackComp_inv`; the B2 + B1-crux bridge | INSTANTIATE `leftAdjointCompIso` on `pushforwardComp` (do NOT equate it with `restrictFunctorComp`); `exact conjugateEquiv_leftAdjointCompIso_inv`, residual concrete iso-hom eq closes by MAP-level merge + `Subsingleton.elim` | iter-046 falsely declared it "irreducible"; the whnf-bomb was `ext` on the conjugate-headed goal — NEVER `ext` before the abstract rewrite. Also: scaffold-keyword needed in objective line for sorry-free files (no-op filter) |
| Bridge B2 `restrictFunctorIsoPullback_comp_compat` (terminal) | 050 · ~3 (048–050) | ~120 | `TensorObjInverse.lean` | pseudonaturality of `restrictFunctorIsoPullback` across `j;ι_U=ι_V`; 6 axiom-clean lemmas (5 per-leg + assembled `_hom`) | conjugateEquiv.injective → LHS-collapse keystone (`= 𝟙`) → N explicit `← conjugateEquiv_comp` splits over fixed `(C,D)=(X.Mod,V.Mod)` → per-leg pushforward values → cancel `pushforwardComp` pair → `conjugateEquiv_reindexCongr`. **`mateEquiv_hcomp/vcomp` UNNEEDED** (all legs share (C,D)) | fine-grained the telescope into atomic per-leg sub-lemmas was the breakthrough after CHURNING on whole-`hNat`; collision RED from a stale private stub of the keystone FQ name (delete it) |
| B1-crux engine `H1inv_app_eq_pullbackVal_restrict` + `sheafPullbackUnit_forget_eq` (terminal) | 053 · ~4 (050–053) | ~250 | `TensorObjInverse.lean` | sheafification-boundary unit coherence; H1inv body + residual both sorry-free, axiom-clean | forget-faithful (`fullyFaithfulForget.map_injective`) + INNER presheaf-pullback transpose + INVERSE-`leftAdjointUniq` triangle (`hAcancel`=`leftAdjointUniq_inv_app`+`unit_leftAdjointUniq_hom_app`) + `sheafificationCompPullback_eq_leftAdjointUniq`; term-mode assembly across the SheafOfModules `≫` seam | CHURNED 3 iters (050–052) on the whole-composite homEquiv transposition (PROVEN circular) before the inner-adjunction/forget-faithful route landed; mathlib-analogist cross-domain (`analogies/ofisrightadjoint-unit.md`) was the unblock |
| v4.31.0 migration: `DualInverse` + `TensorObjSubstrate` | 090 · 2 (089–090) | ~1100 ported | 2 files | DualInverse 6→0, TensorObjSubstrate 5→1 (the 1 = dead private dup), both axiom-clean EXIT 0; recovered K-engine + D3′ port (1030 LOC / 15 helpers) | **9-axis v4.31 fix pattern** (`appIso_inv_naturality` for α-nat; `respectTransparency false` knob; `leftUnitor M.val` over `λ_ 𝟙_` for unit-slot defeq; `erw [id_comp]` clears `𝟙` at `Functor.obj` spelling; `have;simp at;exact` over reducible `simpa`); recovery source = parent `117100c4` + orphan siblings, NOT `main` | LSP DEAD on 3.2M-HB files (broken-pipe) → `trace_state` in build; slice originals in orphans not `main` |
| v4.31.0 migration: ROOT δ/η re-port + B1 + K1 leaf | 095 · 3 (093–095) | ~720 ported | TensorObjSubstrate + new K1 leaf + TensorObjInverse | 13 deleted δ/η-collapse decls re-ported axiom-clean (keystone `pushforward_mu_appIso_collapse`); B1 closed (ZERO fixes); K1 relocated to monster-free leaf `PullbackTensorMapIso.lean` + filled (1 fix) | verbatim v4.30 bodies port with ~0–1 fixes once the keystone exists; **leaf-split = OOM-isolation for a 6.4M-HB proof** (new leaf imports only the monster-free upstream) | a DELETED decl leaves no `sorry` to catch — diff against v4.30 to find dropped machinery; never re-home a heavy decl IN the file whose olean downstream needs warm |
| v4.31.0 migration: S2 + dual-unit FLANK LEAF | 098 · 2 (096+098) | ~120 | TensorObjInverse + `PresheafDualUnitPullback.lean` | S2 filled in-place (096); LEAF closed (098): RED(6 α-NatTrans elab errors)+1 FLANK sorry → sorry-free axiom-clean; L1′ `presheafDualUnitIso_pullback_natural` + linchpin `pushforwardBetaUnitEpsAppOne` (general-`y`) + 2 helpers; sole ∞-source closed (`gaps` 1→0) | α-NatTrans recovery `naturality := f.appIso_inv_naturality`; FLANK collapse = both comparators reduce to the same `(f.appIso V).hom`; `restrictScalars_η` CommRing-synth → abstract `{R S:CommRingCat}` helper; `show` LEFT-assoc composite for `comp_ε` | grep sorry-count masked 6 elab errors in a monster-importing file (NEVER trust grep — BUILD it); OOM "don't build leaf" rule was a stale-2GB-host myth |

## Routes

Seeds 1 (D4′) and 2 (DUAL) delivered. The terminal route is the sole open lane.

### D4′ seed-1 (`pullbackTensorIsoOfLocallyTrivial`) — DELIVERED iter-042
Root `TensorObjSubstrate.lean` green (`lake build` EXIT 0), K1 closed. K1 `hδ` (presheaf oplax
`δ (pullback φ')` iso) realized via the abstract sandwich `isIso_oplaxδ_of_conj` fed the
δ-conjugation identity `pushforward_mu_appIso_collapse` (built on `deltaConjOfMuComparison`),
which conjugates `δ (pullback φ')` to the strong `δ (Gβ)` of `pushforward₀ ⋙ restrictScalars β'`
via `leftAdjointUniq`. This SUPERSEDED the planned helpers `pullbackTensorMap_presheafDelta_eq`/
`pullbackTensorComparison` (never realized). Witness K1 `pullbackTensorMap_isIso_of_isOpenImmersion`
is PUBLIC (L4770). HAZARD CONFIRMED: iters 039–041 "delivered" were LSP stale-green — `lake build` only.

### Terminal `exists_tensorObj_inverse` (`TensorObjInverse.lean`) — ACTIVE (unblocked iter-042)
`L⁻¹ := dual L` (loc-triv by C-bridge `dual_isLocallyTrivial`); glue local left-unitor
contractions `(L⊗dual L)|_U ≅ 𝒪_U` via A-bridge `homOfLocalCompat` + `tensorObj_restrict_iso`;
globalise via B-bridge `isIso_of_isIso_restrict`. Object + C/A/B bridges + cocycle skeleton
done. `trivialisation_restrict_compat` (overlap cocycle `hf`: real ab-group section maps, NOT
global `subsingleton`) decomposes into 5 restriction-naturality squares S2–S4c + reindex defs
(ρ `restrictCompReindex`, u_ι `unitRestrictIso`). **Bridge B2 (`restrictFunctorIsoPullback_comp_compat`)
FULLY CLOSED iter-050** (leg-by-leg `conjugateEquiv_comp`, NOT `mateEquiv_vcomp`). S4c CLOSED
iter-041. **Engine DONE: B1-crux `H1inv_app_eq_pullbackVal_restrict` + `sheafPullbackUnit_forget_eq`
both sorry-free iter-053.** Remaining = the 5 restriction-naturality squares: TENSOR flank S2/S4b
(ACTIVE iter-054, B1-route, all ingredients proven) → DUAL flank S3/S4a (BLOCKED, dual-B1 gap) →
telescope `trivialisation_restrict_compat` (gated on all 5).

**Route of record (iter-042, direct base-change — replaces the iter-040/041 per-leg + the
rejected monoidal-packaging attempts).** Keystone **B1**
(`tensorObj_restrict_iso_eq_pullbackTensorMap`): relate the structural iso to the comparison
MAP, `tensorObj_restrict_iso f = restrictFunctorIsoPullback f ≫ asIso(pullbackTensorMap f) ≫
reindex`. Both share the `restrictFunctorIsoPullback`/`sheafificationCompPullback` prefix; after
cancelling it B1 is the presheaf-level core `δ = leftAdjointUniq∘μIso`, discharged by the SAME
δ-conjugation K1 used (`pushforward_mu_appIso_collapse`/`isIso_oplaxδ_of_conj`) + `leftAdjointUniq`
uniqueness (bounded, no `MonoidalCategory`). Squares S2/S4b (tensor) then follow from `pullbackTensorMap_restrict` +
`pullbackTensorMap_natural` (sorry-free D3′ cone) + B1 transported along
`restrictFunctorIsoPullback`; S3/S4a are the dual analogue. Telescope wires the 5 squares.
**B1 unblocked iter-044:** the root δ-conjugation lemmas (`pushforward_mu_appIso_collapse`,
`deltaConjOfMuComparison`, `isIso_oplaxδ_of_conj`, `pushforward_lax_mu_comparison(_lhs/_rhs_tmul)`)
were `private`; de-privatized iter-044 (refactor, signature-preserving, root stays green EXIT 0).
Lane SOLO/race-free (root frozen-green again post-edit).

### Consumer seed-3 `addCommGroup_via_tensorObj` (`RelPicFunctor.lean`) — BLOCKED
Group on loc-triv iso-classes: `map_add` ← seed-1 comparison iso; `map_zero` ←
`pullbackUnitIso`; inverse ← `exists_tensorObj_inverse`. Gated on seed-1 (done) + terminal.

## Open strategic questions

- Monoidal packaging of `pullback f`: REJECTED — `MonoidalCategory (X.Modules)` absent
  (`#synth` fails; Mathlib has it only at presheaf level). Direct base-change route chosen.
- `Functor.Monoidal (pullback φ)` refactor: **RESOLVED — DO NOT BUILD (analogist iter-056,
  `analogies/pullback-monoidal-scope.md`).** (1) The OPLAX instance already exists sorry-free (`:1115`);
  the S4b residual was never "missing monoidality" — it is sheaf-transport (Cone A). (2) A STRONG
  `Functor.Monoidal` is globally FALSE: δ=`pullbackTensorMap` is not iso for general modules
  (`Γ(ℙ¹,𝒪(1))=0`), iso only on line bundles via the chart-chase. (3) Even a strong instance would NOT
  close S3/S4a — Mathlib has no monoidal/closed dual-preservation matching `f^*`. Dual = bespoke Cone B.
- Dual side S3/S4a: route SETTLED = **Cone B** bespoke internal-hom base-change naturality
  (generalize `presheafDualUnitIso_naturality` to the immersion `j`); NOT the abandoned
  `pullbackDualMap` cone nor the subsingleton route. Land after Cone A validates the seam pattern.
- Coverage debt: ~97 unmatched `lean_aux` decls; scheduled cleanup phase (blueprint blocks for
  load-bearing helpers, `private` for internals). `TensorObjSubstrate.lean` split next refactor.
- Consumer (when unblocked): blueprint must state which group axioms ride the associator vs the
  comparison iso, so the consumer assumes no more than additivity-of-pullback.
- Out of scope (sibling extracts): A.2.c/Quot, Čech, A.3/A.4, Route-C — disjoint cones.

## Mathlib gaps & new material

Gaps to fill:
- A-bridge `homOfLocalCompat` (+ `homOfLocalCompat_restrictFunctor_map`) — glue compatible local
  module morphisms to a global one; built project-side. DONE.
- B1 presheaf core `δ = leftAdjointUniq∘μIso` — by hand via `pushforward_mu_appIso_collapse`
  + `leftAdjointUniq` uniqueness (NOT a Mathlib gap; bounded sectionwise mate identity).

New project material:
- By-hand `AddCommGroup` on loc-triv iso-classes (no `MonoidalCategory (X.Modules)`; modeled on
  Mathlib `CommRing.Pic.mapAlgebra`).
- `IsInvertible M := ∃N, M⊗N≅𝒪` carrier for `Pic X` (Stacks 0B8K/01CX).

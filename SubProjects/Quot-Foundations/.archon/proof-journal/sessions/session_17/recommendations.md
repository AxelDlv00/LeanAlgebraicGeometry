# Recommendations for the next plan iteration (post iter-017)

## Subagent findings (CRITICAL / HIGH first)

**No CRITICAL / HIGH / must-fix findings from any review subagent this iter.** All four dispatched
(lean-auditor `iter017`, lean-vs-blueprint-checker `fbc`/`gf`/`quot`). Summary of landed findings:

- **lean-auditor `iter017` — PASS, 0 must-fix, 0 major, 2 minor, 0 excuse-comments.** All 18 new decls
  verified genuine + axiom-free; the `.1`/`.2` refactor in `base_change_mate_codomain_read` confirmed a
  genuine refactor (type unchanged); `gf_torsion_reindex` signature change confirmed a simplification,
  not a weakening; L5 genuinely closed; 13 QUOT decls genuine, `omit` legitimate. All `maxHeartbeats`
  bumps justified (≤4M, explanatory comments, no loop-masking). Minors: stale parent-repo STATUS
  iter-numbers in FBC (pre-existing, prover-cleanup); Seam-2 sorry open (expected).
- **lean-vs-blueprint-checker `fbc` — faithful, 0 must-fix, 0 major, 3 minor.** The chapter's Seam-2
  i/ii/iii decomposition accurately describes the landed `…_legs` implementation; all 32/37 pinned
  decls match (5 unpinned = the known Seam-2 coverage debt). MEDIUM-ish housekeeping for the planner
  (see below).
- **lean-vs-blueprint-checker `gf` / `quot`** — folded in once they return (gf re-dispatched as `gf2`
  after a transient API socket error on the first run; quot still processing).

## Closest-to-completion / highest-leverage targets

1. **FBC Seam 2 — close `base_change_mate_fstar_reindex_legs` (step-iii only).** The structural wall is
   GONE; the residual is a single isolated, precisely-scoped categorical mate-unwinding on one concrete
   affine goal. Dispatch a **`prove` pass on `base_change_mate_fstar_reindex_legs` only**, directive:
   after `subst` + the (ii) Γ-collapses, rewrite the surviving `(g')`-unit factor by `key`
   (`pullbackPushforward_unit_comp`), absorb the `e`-unit as an iso
   (`pullback_isEquivalence_of_iso`/`base_change_mate_codomain_read_legs`), read the `Spec ιA`-unit's
   Γ-value via Seam 1 `base_change_mate_unit_value`, compose with the codomain read + `restrictScalars
   ψ` → `base_change_mate_inner_value`. Closing this lands Seam 2 fully and unblocks Seam 3
   (`base_change_mate_gstar_transpose`, whose crux is the `pullback_spec_tilde_iso` counit-naturality,
   distinct from Seam 2) → cascades to `section_identity`/`generator_trace`/`cancelBaseChange`.
   **HARD GATE note:** the 5 new FBC decls need `\lean{}` pins + blueprint blocks first (see coverage
   debt). The FBC chapter already decomposes Seam 2 into steps i/ii/iii (blueprint-reviewer `fbc-fastpath`
   cleared it iter-017), so a thin pin-adding writer round suffices — confirm via the lvb-fbc report
   below before the prover.

2. **GF — L4 `exists_localizationAway_finite_mvPolynomial` is now the GF critical path** (L5 closed this
   iter). It is the genuine Mathlib-absent Noether-normalisation descent. **Effort-break it into the two
   scouted sub-pieces before dispatching a prover:**
   - (a) **Algebraic-independence descent** (φ injectivity): `b_j := gK(X_j)` alg-independent over `K`,
     restrict along `A_g ↪ K` (the `IsLocalization.map … hle` embedding from `gf_clear_one_denominator`)
     → independence over `A_g` → φ injective. Atom: `AlgebraicIndependent.restrictScalars` /
     `MvPolynomial.aeval_injective`.
   - (b) **Module-finiteness descent** (denominator clearing): Finset-fold of `gf_clear_one_denominator`
     (CLOSED, reusable) over the integral-dependence coefficient polynomials → `Module.Finite
     (MvPolynomial (Fin s) A_g) B_g`.
   Then `genericFlatnessAlgebraic` (route through L4+L5) becomes dispatchable.

3. **QUOT — the finiteness encoding is the next dedicated lane.** D6 + the full ambient homogeneity
   calculus are landed axiom-clean as ready inputs. The next lane is large and self-contained; run it as
   its OWN dispatch (do not bundle with another file). Precise 4-step plan (from the prover's QUOT
   report):
   1. Fix the **subquotient-datum `structure`** (bundle `N' ≤ N` homogeneous, `t : Fin r → M →ₗ[κ] M`
      pairwise-commuting + `RaisesDegree ℳ (t i)` + `t i` preserves `N, N'`, `[Module (MvPolynomial
      (Fin r) κ) M]` + scalar-tower + `X i • m = t i m` + `Module.Finite`).
   2. `subquotient_finite_transfer` via the `eval(t_{r-1}=0)` surjection +
      `Submodule.FG.restrictScalars_of_surjective` + annihilation-by-`x` (from the ker/coker lemma).
      The finiteness encoding itself: `Algebra.adjoinCommRingOfComm` + `aeval` into the CommRing adjoin +
      `Module.compHom` (subalgebra-only route is RULED OUT — use the polynomial ring + `eval`).
   3. `subquotient_hilbertSeries_rational` — induction on `r`; base via `IsRatHilb.ofEventuallyZero`;
      step feeds D6 (`subquotient_degreewise_diff`) + IH(K) + IH(C) into `IsRatHilb.ofDiffEq`
      (+ `IsRatHilb.bump` to align orders).
   4. Bridge `gradedModule_hilbertSeries_rational` at `(N,N') = (⊤,⊥)`, endos = mult by the `r`
      degree-1 generators.

## 1-to-1 coverage debt (mandatory — `archon dag-query unmatched` = 16 nodes, ALL new this iter)

Every `lean_aux` node below is a proved, axiom-clean Lean declaration with **no blueprint entry**.
The planner should author the blueprint blocks (review agent does not write prose). Grouped by chapter:

**Cohomology_FlatBaseChange.tex** (Seam-2 sub-lemmas — add to the Seam-2 `\uses{}` graph):
- `base_change_mate_codomain_read_legs` — variable-legs restatement of `base_change_mate_codomain_read`
  (the subst-able device). Deps: `pullback_spec_tilde_iso`, `pushforward_spec_tilde_iso`,
  `ModuleCat.extendScalars`/`restrictScalars`.
- `base_change_mate_fstar_reindex_legs` — variable-legs Seam-2 chain (carries the lone step-iii sorry).
  Deps: `base_change_mate_codomain_read_legs`, the three `gammaMap_pushforward*` collapses, `key`.
- `gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id` — `(pushforwardComp
  a b).hom/inv.app M = 𝟙` then `Functor.map_id`. Deps: `Scheme.Modules.pushforwardComp_hom_app_app`.
- `gammaMap_pushforwardCongr_hom` — congruence coherence collapses to `eqToHom`. Deps: `subst` + `ext`.

**Picard_QuotScheme.tex** (new subsubsection "Ambient homogeneity calculus" under
`subsec:gradedModuleApi`, feeding `lem:graded_subquotient_ker_coker` + `lem:graded_subquotient_degreewise_diff`):
- `RaisesDegree` (def), `RaisesDegree.mem` — abstract degree-1 endo predicate. Deps: `Submodule.map`,
  `Submodule.mem_map_of_mem`.
- `decompose_raisesDegree`, `decompose_raisesDegree_zero` — degree-shift commutation (load-bearing).
  Deps: `DirectSum.sum_support_decompose`, `DirectSum.decompose_sum`, `DirectSum.sum_apply`,
  `DirectSum.decompose_of_mem_same`/`_ne`, `AddSubmonoidClass.coe_finset_sum`.
- `comap_isHomogeneous`, `map_isHomogeneous` — preimage/image of homogeneous under degree-raising endo.
  Deps: `Submodule.IsHomogeneous.mem_iff`, `decompose_raisesDegree`(`_zero`).
- `inf_isHomogeneous`, `sup_isHomogeneous` — lattice closure (Mathlib-absent). Deps:
  `Submodule.IsHomogeneous.mem_iff`, `DirectSum.decompose_add`, `DirectSum.add_apply`,
  `Submodule.add_mem_sup`.
- `map_inf_degree_eq` (ambient image identity), `sup_inf_degree_eq` (ambient distributive law).
  Deps: `decompose_raisesDegree`, the homogeneity lemmas, `DirectSum.decompose_of_mem_same`.
  (`finrank_comap_subtype` is `private`, so it does not appear in `unmatched`; no pin needed.)

`subquotientHilb` (`def:graded_subquotientHilb`) and `subquotient_degreewise_diff`
(`lem:graded_subquotient_degreewise_diff`) already have matching pins — no action.

## Blocked targets — do NOT re-assign without the named structural change

- **FBC `base_change_mate_fstar_reindex_legs` step-iii** is NOT churning — it is a freshly-isolated,
  dispatchable goal (the motive wall is dissolved). Assign it (per #1) — this is the opposite of the
  CHURNING do-not-retry case.
- **QUOT finiteness encoding** (`subquotient_hilbertSeries_rational`, `subquotient_finite_transfer`) is
  a deferred large build, NOT a stuck wall. Assign it as its own lane (per #3); do not attempt
  partially (would leave a `sorry` and break the no-sorry invariant). The subalgebra-only finiteness
  route is RULED OUT — use the polynomial ring + `eval(t_{r-1}=0)` surjection.
- **GF `gf_torsion_reindex` OreLocalization diamond is RESOLVED** (producer-side, dropped the canonical
  existential). Remove it from the "known blocker" watch — L5 is closed.

## Reusable proof patterns discovered this iter

- **Subst-able free legs** dissolve "motive is not type correct" walls; pair with `.1`/`.2` projections
  (not `obtain`) at the consumer for proof-irrelevant defeq.
- **Don't bundle canonical (`inferInstance`) instances** as existential witnesses — opaque fvars break
  `OreLocalization`/`LocalizedModule` instance matching.
- **Single-κ-linear-map route** for degreewise dimension differences avoids quotient constructions and
  `N' ≤ N`.
- **Route-2 ambient-`M` graded calculus is pathology-free** — keep every graded object as `Naux ⊓ ℳ n`.

## Blueprint housekeeping (MEDIUM — from lvb-fbc; planner action, low urgency)

- **Stale `\uses{lem:base_change_regroup_linearEquiv}` in `lem:base_change_mate_regroupEquiv`** — that
  helper is a pure-blueprint label with no `\lean{}` and no Lean decl (the construction was inlined).
  Either drop it from the `\uses` or annotate it "inline helper, no separate Lean declaration". (Already
  noted in PROJECT_STATUS since iter-011; re-surfaced by lvb-fbc.)
- **(Optional)** Add a step-(ii) prose note in `lem:base_change_mate_fstar_reindex` that
  `pushforwardComp.hom` collapses inside step (iii) (discrimination-tree miss under `simp` at the
  step-(ii) position) — purely tactic-level, math content is correct.

## Subagent landed findings

- **lean-auditor `iter017`** — `task_results/lean-auditor-iter017.md`. PASS, 0 must-fix / 0 major /
  2 minor / 0 excuse-comments. "Project is in good structural health for iter-017 handoff."
- **lean-vs-blueprint-checker `fbc`** — `task_results/lean-vs-blueprint-checker-fbc.md`. Faithful;
  0 must-fix / 0 major / 3 minor (the two housekeeping items above + the expected 5-decl coverage debt).
  Seam-2 i/ii/iii chapter decomposition confirmed accurate.
- **lean-vs-blueprint-checker `gf` (`gf2`)** — _(folded in on return)_.
- **lean-vs-blueprint-checker `quot`** — _(folded in on return)_.

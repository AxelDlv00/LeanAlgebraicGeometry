# Progress-Critic Directive — iter 250

Assess convergence of the single active prover route below. Fresh-context read: do NOT assume the
planner's framing is correct.

## Active route: A.1.c.sub — Lane TS (`Picard/TensorObjSubstrate.lean`), D2′ comparison-iso unit square

Single active route. One file. The route's job: close the D2′ unit-square obligation
(`pullbackEtaUnitSquare` → `pullbackTensorMap_unit_isIso`), which is the first canonical
critical-path sorry-elimination of the Picard substrate.

### Last 4 iters — extracted signals

| Iter | Prover status | File sorry (before→after) | Top-level helpers added | What landed | Recurring blocker phrase |
|---|---|---|---|---|---|
| 246 | PARTIAL | 2→1 | +4 (δ-wrapping decls) | D2′ δ-wrapping landed axiom-clean; reduced to the η-bridge `IsIso (a_Y.map (η F))` | "reduced one level, did not close" |
| 247 | PARTIAL | 1→1 | +2 (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) | η-bridge reduced to a single "unit square" eqn | "reduced one level, did not close" |
| 248 | PARTIAL | 1→2 | +4 (atomic step-lemmas, fine-grained) | 2/3 ★ abstract mate-lemmas CLOSED + the `rfl` linchpin (retired the suspected "defeq wall"); D2′ reduced to ONE concrete `(∗∗)` residual | "abstract done, concrete residual remains" |
| 249 | PARTIAL | 2→2 | +0 (all work inside ONE proof) | steps 1–6 of the telescope ASSEMBLED into one compiling axiom-clean proof; `(∗∗)` moved L1672→L1741, NOT closed | "Category.assoc silently fails to match on `.val` composites" |

- **Canonical Picard-cone sorry counter: FLAT for 11 consecutive iters (239–249).** No canonical
  sorry eliminated across the whole arc.
- **Dominant blocker (iter-249 review):** NOT a Mathlib gap and NOT an abstract-math wall — pervasive
  Lean tactic friction (`Category.assoc`/`reassoc`/`rw` silently failing to match on
  `PresheafOfModules`-over-`Sheaf.val` composites). The abstract mate-calculus is fully discharged.
- The residual is ONE concrete presheaf identity with a documented 3-substep recipe (i)/(ii)/(iii),
  the SOLE genuinely-new math item being a sectionwise lemma `epsilonPresheafToSheafUnit` (step 7).

### Strategy estimates for this route (verbatim from STRATEGY.md `## Phases & estimations`)
- Iters-left cell: "D2':≤1, then D3'/D4' ~6–12".
- Route entered its current phase (D2′ atomized → one concrete residual) at iter-248.
- LOC cell: "~140–320 · ~3 helper/it".

### This iter's planned dispatch (PROGRESS.md `## Current Objectives` proposal)
- **1 file, 1 lane:** `Picard/TensorObjSubstrate.lean` — close the `(∗∗)` residual at L1741.
- The plan is NOT a verbatim re-dispatch: per the iter-249 armed corrective, iter-250 first runs a
  **mathlib-analogist (api-alignment)** consult on the presheaf↔sheaf `ε` reconciliation + the
  `SheafOfModules`/`PresheafOfModules` `.val` morphism-action idiom, authors
  `epsilonPresheafToSheafUnit`, and runs a focused concrete (i)/(ii)/(iii) pass using the recorded
  working idiom — then, only if THAT also fails, classifies true STUCK.
- No second lane: RPF (`RelPicFunctor.lean`) is converged + doc-clean and gated cross-file on D4′,
  which itself is gated on D2′→D3′ in this same file (linear chain ⇒ structurally one lane).

### Questions for you
1. Verdict for route A.1.c.sub (CONVERGING / CHURNING / STUCK / UNCLEAR), and the corrective TYPE if
   not CONVERGING.
2. Is the iter-250 plan (analogist-idiom consult + author step-7 + focused concrete pass, explicitly
   NOT another abstract helper round and NOT a re-decomposition) the right response to the trajectory,
   or is a harder pivot warranted now (e.g. abandon the manual chase for a different proof shape, or
   route-level rethink)?
3. Dispatch-sanity: is 1 lane the correct dispatch count given the linear-chain structure (M
   available = 1), or is the planner under-dispatching?

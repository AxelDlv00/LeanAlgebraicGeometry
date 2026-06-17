# Progress-critic directive — iter-037

Assess convergence of the SINGLE active prover route (01I8: affine quasi-coherence
equivalence `F ≅ ~(Γ F)` on `Spec R`). K = 5 iters of signals below. Report a per-route
verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, if not CONVERGING, the corrective TYPE.

## Route: 01I8 `F ≅ ~(Γ F)` for quasi-coherent `F` on an affine scheme
Files touched over the window: `TildeExactness.lean`, `QcohRestrictBasicOpen.lean`,
`QcohTildeSections.lean`. All lanes are `mathlib-build` mode (no-sorry invariant), so the
project sorry count is irrelevant — it sits flat at 2 (both frozen/superseded) the whole
window. The convergence metric is: *has the named unconditional 01I8 target been reached?*
It has NOT.

### Per-iter signals (helpers added per iter; prover status; named-target state; blocker phrase)
- iter-032: `QcohTildeSections` +7 axiom-clean (pure-algebra descent `isLocalizedModule_of_span_cover`, P1b). Named unconditional target ABSENT. Blocker: needs geometry (P1a).
- iter-033: `TildeExactness` (NEW) +3 axiom-clean (Route-P step P3). PARTIAL. Named target `tildePreservesFiniteLimits` ABSENT. Blocker: Ab-stalk mono transport.
- iter-034: `TildeExactness` +2 axiom-clean. PARTIAL. Named target `tildePreservesFiniteLimits` still ABSENT. Blocker: σ_x R-linear packaging + jointly-reflecting assembly. (Plus a separate 02KG cover-system lane, not this route.)
- iter-035: `QcohRestrictBasicOpen` (NEW) +5 axiom-clean (P1a L1: geometric base-change MODULE transport `modulesRestrictBasicOpen`, `D(f)≅Spec R_f`, DONE). `TildeExactness` +4 axiom-clean, PARTIAL, named target still ABSENT. Blocker (both): absent-Mathlib **tilde base-change** (`tilde_restrict_basicOpen`, Stacks lemma-widetilde-pullback).
- iter-036: PIVOT Route P → Route B (section-localization) — dropped `TildeExactness`/`tildePreservesFiniteLimits` from the critical path. `QcohTildeSections` +3 axiom-clean (Route-B local-model bricks: `tilde_section_isLocalizedModule`, `section_isLocalizedModule_of_isIso_fromTildeΓ`, `section_isLocalizedModule_of_presentation`). Named keystone `qcoh_section_isLocalizedModule` ABSENT. Blocker: **`.over`→affine base-change bridge** — explicitly the SAME geometric base-change that blocked Route P at iter-035.

### Recurring-blocker observation (the planner wants this stress-tested)
Under BOTH routes the residual collapses to the SAME obstruction: the affine base-change
bridge (`D(g)≅Spec R_g`, restrict a qcoh module + its presentation, identify sections with
localizations). Route B was adopted to AVOID absent-Mathlib walls, yet its keystone hits this
same bridge. Counter-signal the planner sees: the geometric MODULE-transport half of that
bridge (`modulesRestrictBasicOpen`) is ALREADY built (iter-035), so the residual is arguably
now well-localized and shrinking, not merely relocating. Adjudicate: is this CHURNING (helpers
accumulate, named target never closes, same blocker recurs under a cosmetic route relabel) or
CONVERGING (each iter narrows toward a now-buildable bridge with the heavy half done)?

### STRATEGY estimate vs elapsed
01I8 row: `Iters left ~3–5`. Entered the Route B phase at iter-036 (1 iter elapsed in current
phase). The broader 01I8 effort has run since ~iter-029.

### This iter's PROGRESS proposal
Build the remaining base-change-bridge glue (presentation-restriction of `F` to `D(g)`;
section-comparison `Γ(D(g),F) ≅ Γ(Spec R_g, modulesRestrictBasicOpen g F)`) as `mathlib-build`
lanes in `QcohTildeSections.lean` / `QcohRestrictBasicOpen.lean`, feeding the keystone. 1–2 files.

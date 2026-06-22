<!-- ARCHON_MEMORY.md — condensed project knowledge for all agents.
     Written by the plan agent and archon discuss. Read by all agents.

     HARD LIMITS: max 10 bullets · ~600 chars total.
     Prune before adding. Only keep what would surprise an agent reading
     the code fresh. Do NOT duplicate things obvious from the codebase.

     Good candidates: dead-end tactics, files not to touch, Mathlib gap
     coordinates, protected invariants, per-file hazards, standing routes
     to avoid, axioms that must not be accepted.

     Bad candidates: things already obvious from the code or PROGRESS.md,
     current sorry counts, task-specific details that change every iter.
-->
- **TRUST ONLY `lake build`, NEVER LSP.** LSP `lean_diagnostic`/`lean_multi_attempt` gave STALE-GREEN on the >4800-LOC root `TensorObjSubstrate.lean` for 3 iters (039–041), masking a RED root (undefined-id stub) — falsely reported seed-1 "delivered". Every close confirmed by `lake build` only.
- **SEED-1 DELIVERED iter-042** — root `TensorObjSubstrate.lean` GREEN, sorry-free, K1 PUBLIC (L4770). K1 `hδ` realized via abstract `isIso_oplaxδ_of_conj` ← δ-conjugation `pushforward_mu_appIso_collapse` (on `deltaConjOfMuComparison`) — SUPERSEDED the phantom `pullbackTensorMap_presheafDelta_eq`/`pullbackTensorComparison` (never existed). Blueprint reconciled iter-043.
- PLAN-VALIDATE TRAPS (each = a 0-dispatch iter): (1) STOP-MARKER (034+035) drops a `## Current Objectives` line whose lowercase has "do not touch/assign/work on"/"off-limits"/"no objective" → say "restrict edits to this file". (2) NO-OP SCAFFOLD (047) drops a line naming a sorry-FREE `.lean` file UNLESS that SAME line carries a scaffold keyword (scaffold|skeleton|stub out|declarations for|does not exist) — to ADD a decl to a sorry-free file, put "scaffold" + the filename on ONE line.
- **TERMINAL ENGINE DONE.** B2 `restrictFunctorIsoPullback_comp_compat` CLOSED iter-050 (fine-grained per-leg `conjugateEquiv.injective`→LHS-collapse(=𝟙)→`←conjugateEquiv_comp` splits over FIXED `(C,D)=(X.Mod,V.Mod)`→cancel `pushforwardComp`; `mateEquiv_hcomp/vcomp` UNNEEDED). B1-crux `H1inv_app_eq_pullbackVal_restrict`+`sheafPullbackUnit_forget_eq` CLOSED iter-053 (forget-faithful + INNER presheaf-pullback transpose + INVERSE-`leftAdjointUniq` triangle; whole-composite homEquiv was PROVEN CIRCULAR; `analogies/ofisrightadjoint-unit.md`). KEYSTONE `conjugateEquiv_restrictFunctorComp_inv` (root, iter-048): instantiate `leftAdjointCompIso` on `pushforwardComp`, NEVER `ext` a conjugate goal. Remaining = the 5 squares.
- **SQUARES.** S2 CLOSED iter-054 (B1-route: sub B1→cancel ρ via B2→`pullbackTensorMap_restrict`+`_natural`; `pullbackTensorMap_restrict` root L3451 is CLOSED — IGNORE its stale "Typed sorry retained" comments L3480/3541). **S4b is NOT a B1 corollary** (iter-055 correction): `tensorObj_unit_iso = sheafified presheaf `λ_ 𝟙`+counit`, NOT pullback-based; close it as a BESPOKE unitor-coherence square (Mathlib `Functor.Monoidal.map_leftUnitor` SHAPE only — no monoidal instance on the restriction functor), δ-leg=S2, η-leg=S4c(`unitRestrictIso`/`pullbackUnitIso`), outer sheafify+counit formal; `analogies/s4b-unitor.md`. FUTURE refactor: register `Functor.Monoidal (pullback φ)` from δ/η → collapses all squares. DUAL flank S3/S4a genuinely BLOCKED: "dual analogue of B1" (`pullbackDualMap`/internal-hom base-change cone) does NOT exist (grep-empty). DEAD: `restrictFunctorComp.hom.naturality`; subst/rcases on `hVU:V≤U`; `simp[restrictIsoUnitOfLE]`; `congr 1`/`Iso.eq_inv_comp`/`Hom.ext`.
- Cancel across defeq-but-not-syntactic `SheafOfModules ≫`/`Iso.hom`: generic single-`[Category C]` lemma applied by `exact` (defeq matches); every `rw`/`simp` of a category lemma MISSES, `erw [Category.assoc]` whnf-bombs (`comp_cancel_mid`). `have ht` via term-mode `exact`.
- K1 carrier diamond RESOLVED (023): defeq composite `Gβ:=pushforward₀OfCommRingCat⋙restrictScalars β'`; drive `simp(zeta:=false)`+`erw` (full simp/`letI`/`transport` re-ADD the diamond — dead).
- PARALLEL-LANE BUILD RACE: a root-churning (Substrate) edit starves downstream lanes of green-build windows (iter-029 lost all 3 lanes). Run root-churning lanes SOLO; co-dispatch downstream only when root frozen/green. AJC `extendScalars`/`pullback0`/`pullbackLanDecomposition` Lan block is DEAD code — do NOT port.
- DUAL route COMPLETE; reopening DualInverse: `inv ε` whnf-times-out, use shallow `_naturality_apply` + `exact` (`dualnat006`).

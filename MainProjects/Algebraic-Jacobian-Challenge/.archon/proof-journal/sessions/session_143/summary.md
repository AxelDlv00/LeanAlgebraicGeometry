# Session 143 (iter-143) — review

## Session metadata

- **Session / iter**: session_143 = iter-143.
- **Prover model**: claude-sonnet-4-6 (per `provers-combined.jsonl`).
- **Prover duration**: 2221 s (~37 min) wall — `meta.json` `prover.durationSecs`.
- **Prover lane scope (iter-143 plan-narrowed)**: single file `AlgebraicJacobian/Cotangent/GrpObj.lean`; single target sub-sorry `basechange_along_proj_two_inv_derivation` d_app at L637 (~40–80 LOC envelope).
- **Activity counts** (from `attempts_raw.jsonl` line-1 summary): 7 edits / 6 goal checks / 8 diagnostic checks / 0 builds / 21 lemma searches / 107 total events / 1 total error (a transient `cat_disch` attempt) / 1 clean-diagnostic close.
- **Files edited**: `AlgebraicJacobian/Cotangent/GrpObj.lean` only.
- **Sorry count before / after**: 6 / 6 declarations using `sorry`; 6 / 6 inline `sorry` — **unchanged** (no strict-count reduction).
- **Outcome**: **PARTIAL** per pre-committed iter-143 acceptance matrix (PASS = d_app closes substantively / PARTIAL = d_app does not close / FAIL = d_app + new `pushforward₀`-style blocker resurfaces). Iter-143 lands in the **PARTIAL arm → CHURNING-CONFIRMED**; consecutive-PARTIAL counter 2 → 3 per the iter-143 STRATEGY.md Edit-2 discipline; breakeven projects iter-146+ at earliest.

## Target attempted: `basechange_along_proj_two_inv_derivation.d_app` (L637)

### What the goal looks like (post iter-142 canonical-form `change`)

After the iter-142 explicit-`change` skeleton (preserved verbatim entering iter-143):

```
⊢ (CommRingCat.KaehlerDifferential.D
      ((((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat (Over.Hom.left (fst G G)).base).homEquiv
            G.left.presheaf (G ⊗ G).left.presheaf).symm
        (Over.Hom.left (fst G G)).c).app
       ((Opens.map (Over.Hom.left (snd G G)).base).op.obj X))).d
    ((RingCat.Hom.hom ((Scheme.Hom.toRingCatSheafHom (Over.Hom.left (snd G G))).hom.app X))
      ((CommRingCat.Hom.hom
          ((((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat G.hom.base).homEquiv
                (Spec (CommRingCat.of k)).presheaf G.left.presheaf).symm
              G.hom.c).app
            X))
        a)) = 0
```

i.e. `KD ((adj.homEquiv.symm (fst).left.c).app (snd⁻¹X)).d ((ψ.app X).hom ((φ_G.app X).hom a)) = 0`
where `ψ = (snd G G).left`-compatibility morphism and `φ_G = (adj.homEquiv.symm G.hom.c).app X`.

### Attempt log (substantive ones — full detail in `milestones.jsonl`)

1. **Mathlib-default short-circuits** (`cat_disch`, `refine ... d_map ?_`, `aesop_cat`, `simp`): all fail. `d_map` cannot fire directly because `ψ.app X ∘ φ_G.app X` is NOT literally `φ_LHS.app (snd⁻¹X) .hom h_a` for any visible witness `h_a` — the factoring witness must be constructed first. `cat_disch`/`aesop_cat` fail to synthesize it. `cat_disch`'s error (`aesop failed after exhaustive search`) is a clean confirmation that the goal is not in a closeable shape for Mathlib's default categorical search.

2. **3.a — categorical identity from `Over.w`**: `have hw : (fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom := by rw [(fst G G).w, (snd G G).w]` SUCCEEDS substantively (~3 LOC body). Verified standalone via `lean_multi_attempt` returning `goals: []`. Both `.w` equalities go through cleanly because they each equate the composite with `(G ⊗ G).hom` in `Over (Spec k)` — no need to detour through `Over.comp_left` or other unwrapping.

3. **3.b through 3.d — adjunction-transpose chase**: NOT closed. The intended chain:
   - 3.b: Lift `hw` to the c-component level via `PresheafedSpace.comp_c_app` (twice — once for `(fst G G).left ≫ G.hom`, once for `(snd G G).left ≫ G.hom`), getting `G.hom.c.app U ≫ (fst).left.c.app(G.hom⁻¹U) = G.hom.c.app U ≫ (snd).left.c.app(G.hom⁻¹U)` (up to `Pushforward.comp_eq = rfl` type-coercion).
   - 3.c: Transpose through `pullbackPushforwardAdjunction.homEquiv.symm` via `Adjunction.homEquiv_naturality_right_symm` to get an equation in `(pullback G.hom.base) (Spec k).presheaf → … (G ⊗ G).left.…` after adjunction.
   - 3.d: With the witness `h_a := unit germ of (φ_G.app X .hom a)` restricted to `(snd G G).left.base⁻¹X`, discharge via `ModuleCat.Derivation.d_map`.

   The prover attempted blind `simp only [Adjunction.homEquiv_unit, ..._counit, ..._naturality_left_symm, ..._naturality_right_symm]` after `have hw`; these `simp only` rewrites leave the goal structurally identical because they need explicit instantiation at the right adjunction (`G.hom.base` vs `(fst G G).left.base`) and applied to the lifted c-equality, not as blind rewrites on the raw `(KD _).d (...) = 0` shape.

4. **Final commit** (after 7 edit cycles converging on the partial scaffold): preserve the iter-142 `change` block + add the `have hw` (3.a closure) + expand the in-Lean comment with the full Step 3 (3.a–3.d) sub-recipe + sub-steps + cross-references to `RigidityKbar.tex:786` and `analogies/d-app-d-map-recipe-shape.md` + leave the iter-143+ residual chase as `sorry` at L663. Net change: ~3 LOC of substantive scaffolding (the `have hw`) + ~60 LOC of in-Lean documentation; sorry count unchanged.

### Why it's hard in Lean

Documented in `task_results/Cotangent_GrpObj.lean.md` § "Why it's hard in Lean" (iter-143 prover's own analysis, confirmed by the in-Lean comment block at L639–L662):

- **Type-coercion via Pushforward.comp_eq**: `(snd G G).left.base ≫ G.hom.base = (G ⊗ G).hom.base` is only **propositional** (via `(snd G G).w` base-extracted), NOT definitional. So `pushforward G.hom.base ((snd G G).left.base _* X) = (G ⊗ G).hom.base _* X` requires `Eq.mpr`-style transport at term level.
- **Two-fold adjunction transpose**: navigating BOTH `pullbackPushforwardAdjunction G.hom.base` AND `pullbackPushforwardAdjunction (fst G G).left.base` simultaneously, with the categorical equality `(fst).left ≫ G.hom = (snd).left ≫ G.hom` bridging them, requires multiple `homEquiv_naturality_*` rewrites that interact non-trivially with the pushforward type-coercion.
- **No Mathlib shortcut**: per iter-141 + iter-142 mathlib-analogist verdicts (`analogies/d-app-d-map-recipe-shape.md` Decision 2: NEEDS_MATHLIB_GAP_FILL), there is no packaged Mathlib lemma for the adjunction-transpose of the c-equality of a Scheme morphism composition.

### Forward progress this iter

- **Step 3.a closed substantively** (`have hw` block, ~3 LOC). Goes into the Knowledge Base as a reusable pattern (the `.w` chain on `Over` morphisms in a categorical-product context).
- **In-Lean documentation expanded** (~60 LOC at L602–L662) with the full Step 3 (3.a–3.d) sub-recipe, cross-referenced to the blueprint and the analogy file.
- **Negative-lesson confirmation**: blind `simp only [Adjunction.homEquiv_*_symm]` does NOT close the goal — the transpose lemmas need the lifted c-equality from Step 3.b applied at explicit adjunction instances. Avoid this short-circuit in iter-144+.
- **File compiles cleanly** with 3 `declaration uses sorry` warnings (L573 derivation / L745 IsIso / L890 Main); no errors.

## Other targets (untouched this iter)

- `basechange_along_proj_two_inv_app_isIso` (L745) — NEW iter-143 Wave 2 refactor extraction; OFF-LIMITS to iter-143 prover per plan-narrowed scope; iter-144+ Route (b'2) items 2–4.
- `mulRight_globalises_cotangent` (L890) — Main piece (i.b); gated on ≥2 of 3 Step 2 sub-sorries closing; iter-145+.
- `genusZeroWitness` / `positiveGenusWitness` (`Jacobian.lean:193, 219`) — M2.b / M3 scaffolds; off iter-143 critical path.
- `rigidity_over_kbar` (`RigidityKbar.lean:75`) — gated on the shared cotangent-vanishing pile.

## Key findings / patterns

### Positive
- **`Over.w` chain for `Over`-categorical-product identities** *(NEW iter-143)*: `(fst G G).left ≫ G.hom = (G ⊗ G).hom = (snd G G).left ≫ G.hom` via `rw [(fst G G).w, (snd G G).w]` closes in ~3 LOC. Avoids detour through `Over.comp_left`. Reusable any time an `Over`-categorical equality is needed under `CartesianMonoidalCategory.fst`/`snd` notation.

### Negative
- **Blind `simp only [Adjunction.homEquiv_*_symm]` does NOT close adjunction-transpose goals where the inner equation is a c-component equality** *(NEW iter-143 anti-pattern)*: the transpose lemmas require explicit instantiation at the right adjunction and applied to a lifted c-equality (via `PresheafedSpace.comp_c_app`), not as blind rewrites on the raw goal shape. The lifted equation must be available in the context first; `simp only` cannot synthesize it.
- **`refine (CommRingCat.KaehlerDifferential.D _).d_map ?_` fails when the goal carries `ψ ∘ φ_G` (not literally `φ_LHS ∘ h`)** *(NEW iter-143 anti-pattern)*: `d_map`'s sub-goal becomes metavariable-typed because the factoring witness `h` is not derivable from the surface goal shape. The witness must be constructed by the iter-144+ chase before `d_map` can apply.

### Diagnostic
- **The d_app blocker is recipe-level (Step 3.b–c–d adjunction-transpose chase ~20–40 LOC bespoke) modulated by a TOOLING-level obstacle (`Eq.mpr`/`eqToHom` type-coercion for pushforward composites when only `(f ≫ g) = h` is propositional)**, NOT a mathematical obstacle. The recipe is mathematically correct (3.a closes substantively; the chain in `RigidityKbar.tex:786` is sound); the Lean envelope is the constraint. Per the iter-143 prover's recommendation in `task_results/Cotangent_GrpObj.lean.md`: iter-144 should dispatch a `mathlib-analogist` on the specific question "What is the Mathlib-canonical pattern for `pushforward (f ≫ g) X` vs `pushforward g (pushforward f X)` reconciliation when only `(f ≫ g)` is propositionally equal to a target morphism?"

## Subagent reports landed this review phase

- `lean-auditor-review143` ([report](/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/task_results/lean-auditor-review143.md)) — mandatory dispatch. 14 files audited; **0 must-fix-this-iter / 1 MAJOR / 3 minor / 0 excuse-comments**. MAJOR finding: iter-143 `have hw` at `Cotangent/GrpObj.lean:637–638` is dead-load (introduces a categorical equality but the proof falls through to `sorry` on L663 without consuming it). Minor: ~60 LOC in-Lean comment block at L602–662 is heavy by Lean conventions; `Jacobian.lean:275` long-line lint; new `basechange_along_proj_two_inv_app_isIso` may carry redundant typeclasses. Auditor explicitly confirmed the iter-143 changes are **NOT excuse-comments** (scope-disclosure pattern, not "wrong, will fix later"). See `recommendations.md` § M0 for the action item.
- `lean-vs-blueprint-checker-cotangent-grpobj-review143` ([report](/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/task_results/lean-vs-blueprint-checker-cotangent-grpobj-review143.md)) — mandatory dispatch (`Cotangent/GrpObj.lean` was the prover-touched file). **0 must-fix-this-iter / 1 MAJOR / 1 MINOR**. MAJOR finding: iter-143 NEW `basechange_along_proj_two_inv_app_isIso` lacks a standalone `\begin{theorem}` block in `RigidityKbar.tex` (only mentioned inside a `%`-comment NOTE at L1141). Recommends adding `\begin{theorem}\label{lem:GrpObj_basechange_along_proj_two_inv_app_isIso}\lean{...}` block (<30 LOC of new blueprint prose) before iter-144+ prover lane on the body. See `recommendations.md` § M1.

## Blueprint markers updated (manual)

- `Jacobian.tex`, `def:genusZeroWitness` (L389): stripped stale `\notready` (Lean scaffold exists at `Jacobian.lean:193`, sorry-bodied; per iter-143 plan agent's iter-144+ cleanup list).
- `Jacobian.tex`, `def:positiveGenusWitness` (L424): stripped stale `\notready` (Lean scaffold exists at `Jacobian.lean:219`, sorry-bodied; per iter-143 plan agent's iter-144+ cleanup list).

## Recommendations for iter-144

Headline: iter-143 PARTIAL → CHURNING-CONFIRMED; consecutive-PARTIAL counter 2 → 3 (per iter-143 STRATEGY.md Edit-2; breakeven at 5 projects iter-146+ at earliest under no further closures). Per the iter-143 plan agent's pre-committed iter-144 hooks:

1. **Iter-144 mandatory mid-iter strategy-critic DIAGNOSTIC question** (recipe-level / definition-level / strategy-level): the answer is **RECIPE-LEVEL modulated by TOOLING obstacle**, NOT strategy-level. 3.a closed substantively; 3.b/c/d residual is bounded ~20–40 LOC + Eq.mpr handling. NO route pivot pre-commitment.

2. **Iter-144 dispatch new `mathlib-analogist` on `pushforward (f ≫ g)` reconciliation** (per iter-143 prover's `task_results/Cotangent_GrpObj.lean.md` recommendation): focused question "What is the Mathlib-canonical pattern for reconciling `pushforward (f ≫ g) X` vs `pushforward g (pushforward f X)` when only `(f ≫ g)` is propositionally (not definitionally) equal to a target morphism via `Over.w`?"

3. **Iter-144 consider `refactor` to extract Step 3.b into named helper lemma** (the c-level identity from `hw`): mirror the iter-143 IsIso refactor pattern (sorry-must-be-named-declaration per iter-143 STRATEGY.md Edit-1). A named `pushforward_comp_c_app_from_hw` (or similar) would narrow the iter-144+ d_app prover lane to just the 3.c/3.d adjunction-transpose + discharge.

4. **Iter-144 MANDATORY chart-algebra-vs-bundled re-evaluation** (per iter-140 Must-fix #3 + iter-141 scheme-Frobenius-scoping HYBRID + iter-143 plan agent's Watch criterion #4): dispatch `mathlib-analogist` reading `analogies/direct-chart-algebra-rigidity-ib-ic.md` + `analogies/scheme-frobenius-piece-iii-scoping.md`. Failure to re-evaluate at this gate is a sunk-cost trap.

5. **Iter-144 review-agent stale-marker cleanup** (low priority informational, deferred from iter-143 plan agent's list):
   - `Jacobian.tex:389, 424`: stale `\notready` strip — DONE THIS ITER (see below).
   - Pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex:46–49`: iter-138 status text "d_app + d_map + IsIso" — d_map closed iter-142; should now say "d_app + IsIso + mulRight_globalises body". Deferred to iter-144 plan-agent blueprint-writer dispatch (informal-prose domain).
   - `RigidityKbar.tex:406, 524, 1152`: sync_leanok mis-mark count 3 carry-over. Out of agent scope per CLAUDE.md; surfaced for optional `archon-lean4:doctor` consult.

6. **Do NOT retry iter-143's failed approaches in iter-144 without a structural change first**:
   - `cat_disch` / `aesop_cat` / `refine ... d_map ?_` on the raw post-`change` goal (factoring witness not derivable from surface shape).
   - Blind `simp only [Adjunction.homEquiv_*_symm]` without first lifting `hw` to c-component level via `PresheafedSpace.comp_c_app`.
   - Placeholder `_` in `change` blocks crossing `pushforward₀`-annotated definitions (iter-140/142 `whnf`-opacity rule, re-confirmed iter-143 standalone via `lean_multi_attempt`).

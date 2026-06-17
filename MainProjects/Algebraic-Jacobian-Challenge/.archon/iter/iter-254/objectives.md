# Iter-254 — per-lane prover objectives (detail)

This file carries the per-step recipes + bars for the two prover lanes. PROGRESS.md `## Current
Objectives` points here. Read your lane's section IN FULL before editing Lean.

---

## Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean`  [prove]

**Headline:** the `homOfLocalCompat` blocker was a SELF-IMPOSED THROTTLE. `homOfLocalCompat` is **NOT a
protected declaration** (verified: `archon-protected.yaml` lists only `Genus.lean`, `Jacobian.lean`,
`AbelJacobi.lean`; `homOfLocalCompat` is absent) and it has **no compiling caller** (its only consumer
`exists_tensorObj_inverse` in `TensorObjSubstrate.lean` is itself a sorry). So you MAY and SHOULD re-sign
its `hf` hypothesis. The in-file comment claiming `hf` is "PROTECTED, frozen" is WRONG — disregard it and
delete it.

### STEP A (PRIMARY) — re-sign `hf` + close `homOfLocalCompat` (sorries ~L565, ~L581)

1. **Re-sign `hf` to the honest sectionwise form.** Replace the current
   `hf : ∀ i j, HEq ((pullback (resLE …)).map (f i)) ((pullback (resLE …)).map (f j))`
   — which is unsatisfiable (the two `Scheme.Modules.pullback`-images live in only-*isomorphic*,
   not propositionally-equal, sheafification objects, so every `HEq`-elimination fails) — with:

   ```
   hf : ∀ i j (V : Opens X) (hVi : V ≤ U i) (hVj : V ≤ U j),
       (f i).val.app (op ((U i).ι ⁻¹ᵁ V)) ≫ N-conjugation
         = (f j).val.app (op ((U j).ι ⁻¹ᵁ V)) ≫ N-conjugation
   ```
   i.e. for all `i j` and every open `V ≤ U i ⊓ U j`, the two section maps `(f i).val.app` and
   `(f j).val.app` agree in the FIXED abelian-group hom-type `M.val(V) ⟶ N.val(V)`. Use whatever exact
   spelling (with the `eqToHom`/down-set conjugations) makes the goal after
   `simp only [homLocalSection]` (iter-253 reduced it to exactly this equation) close DIRECTLY. The
   blueprint proof of `lem:sheafofmodules_hom_of_local_compat` sub-step (a) (rewritten this iter by
   bw254) now describes this sectionwise hypothesis and the direct bridge — READ it.

   Pick the form the *caller* can actually produce: two local morphisms that literally agree on overlaps.
   You decide the precise indexing (`V` + two `≤` proofs, vs an `Over (U i ⊓ U j)` packaging) — choose
   the one that makes BOTH (a) provable AND a caller able to supply it. Update the docstring (currently
   contradicts the body per aud253 major #3) to match.

2. **Close (a) `IsCompatible`.** With sectionwise `hf`, the iter-253 reduction (goal =
   `M.map(eqToHom) ≫ (f i).val.app … ≫ N.map(eqToHom) = M.map(eqToHom) ≫ (f j).val.app … ≫ N.map(eqToHom)`)
   closes by feeding `hf i j V …` conjugated through the `eqToHom`s, with the thin-poset route-difference
   collapsed by `Subsingleton.elim` (the genuine, correct use). Should be direct/near-direct.

3. **Close (c) sectionwise `𝒪_X`-linearity** `hg` (L581): on each `U i` the glued section satisfies
   `g|_{U i} = f i` (from `(hglue hcompat).choose_spec`), so linearity holds there; `N.val`-separatedness
   propagates it globally. Then `Scheme.Modules.homMk g hg : M ⟶ N`. (b) `topSectionToHom` is already
   CLOSED — reuse it.

**REVERSING SIGNAL (Route-2):** if after re-signing `hf` the goal does NOT reduce/close as diagnosed in
iter-253 (i.e. a NEW obstacle appears) → STOP, do NOT thrash, report the exact new goal state + which
`hf` spelling you chose. Do not proceed to STEP B in that case.

### STEP B (attempt, only if STEP A closes) — `dual_restrict_iso` Step-4 (sorry ~L256)
Armed `analogies/dual252.md` (`dual` is NOT sectionwise). Try, in order:
(1) the **inverse-uniqueness shortcut** from CLOSED `tensorObj_restrict_iso` if tractable;
(2) else leg (A) `sliceDualTransport` (slice-site Hom base-change; build standalone first) + leg (B)
`restrictScalarsRingIsoDualEquiv`. `overSliceSheafEquiv` is confirmed inapplicable to leg (A).
If leg (A) resists → switch to the shortcut, do NOT thrash leg A; leave a concrete one-line handoff.

**Bar:** CLOSE `homOfLocalCompat` (deps all closed; blueprint-armed; the only blocker was the self-imposed
freeze). Attempt Step-4; real compiling partial + a one-line handoff naming which route was tried.
**Guardrails:** stay in `DualInverse.lean`; do NOT edit `TensorObjSubstrate.lean`; do NOT close
`exists_tensorObj_inverse` this iter.

---

## Lane TS-cmp — `Picard/TensorObjSubstrate.lean`  [prove]

**Headline:** Route 1 is STUCK (pc254): 4 iters / 3 disproven approaches on the `restrictScalars(𝟙)`-
over-sheafification `whnf` wall + the two-defeq-monoidal-instance whisker collision. The named
corrective — a cross-domain mathlib-analogist consult (`analogies/tscmp254.md`, tscmp254) — RETURNED a
decisive structural reformulation. You are held STRICTLY to it. The three disproven approaches are
**BANNED** and any relapse is the reversing signal (see below):
- (✗) `letI instMS` instance-unification + `whisker_exchange` across the two instances (disproven iter-252);
- (✗) element-level `TensorProduct.induction_on` + `erw` `≫`-bridge (whnf timeout, iter-253);
- (✗) extracting a uniform-instance helper on the `X.ringCatSheaf.obj` spelling (synth-fail ×4, iter-253).

### The prescription (tscmp254 — read `analogies/tscmp254.md` IN FULL first)
The square is a **monoidal-functor comparison naturality in disguise.** Recast it onto the **two
single-sided naturality lemmas** of the sheafification monoidal functor — the SAME functor S2 already
uses (`Functor.OplaxMonoidal.δ_natural` at ~L2016). Each single-sided lemma whiskers on ONE side against
ONE `μ`/`δ`, so **every term stays in a single `MonoidalCategoryStruct` instance — the cross-group
crossing never forms and `tensorHom_def` is never needed.** This is exactly how Mathlib makes
sheafification monoidal (`Sheaf.monoidalCategory`/`LocalizedMonoidal` read `μ_natural_left :=
NatTrans.naturality_app …` off a bifunctor iso, never `whisker_exchange`). Do NOT instantiate
`LocalizedMonoidal` literally (needs `MonoidalClosed` + `J.W.IsMonoidal`, DEAD per memory ts233) — borrow
only the principle via the δ/μ lemmas.

Three coordinated moves:

1. **STEP A — recast `sheafifyTensorUnitIso_hom_natural` (~L1914) via `δ_natural_left`/`δ_natural_right`**
   (or `μ_natural_left`/`μ_natural_right` — pick the variance matching `sheafifyTensorUnitIso`). [verified]
   `Functor.OplaxMonoidal.δ_natural_left`/`δ_natural_right` (`Mathlib/CategoryTheory/Monoidal/Functor.lean:246,250`,
   both `@[reassoc (attr := simp)]`); `μ_natural_left`/`μ_natural_right` (`:70,74`, `@[reassoc (attr := simp)]`).
   **Least-invasive first:** try proving the naturality by rewriting with the single-sided δ/μ lemmas
   directly (the goal's η-whiskers ARE the `μ`/`δ` of `sheafification ⋙ forget`), WITHOUT changing the
   def of `sheafifyTensorUnitIso` — if `sheafifyTensorUnitIso.hom` is already defeq to a composite of one
   `δ`/`μ` whiskered on each side, the two `_left`/`_right` lemmas close it.
   Only **if** that is blocked: restate `sheafifyTensorUnitIso` so it is *literally* the comparison
   `δ`/`μ` of `sheafification ⋙ forget`, then the lemmas apply by construction. If you restate it, keep
   D2′ (`pullbackTensorMap_unit_isIso`, CLOSED) GREEN — it consumes `sheafifyTensorUnitIso`.

2. **STEP A/B spelling pin — state `pullbackTensorMap` and its helper isos on the SINGLE canonical
   ring-functor spelling** `X.presheaf ⋙ forget₂ CommRingCat RingCat` (where the monoidal instance is
   registered: `Mathlib/Algebra/Category/ModuleCat/Presheaf/Monoidal.lean:32,104-105`), NOT
   `Sheaf.val X.ringCatSheaf` nor `X.ringCatSheaf.obj`. This is the root of BOTH the STEP-A instance
   collision AND the STEP-B Square-2 `Sheaf.val`/`.obj` `Functor.comp_map` merge (~L2006–2027) — pinning
   the spelling clears both. Make the minimal change that removes the `letI instMS` bridges; do not
   gratuitously restate decls D2′ depends on unless required (keep the file green at each checkpoint).

3. **Strip `restrictScalars (𝟙)` EAGERLY** with `rw [restrictScalarsId_map]` (the project's own lemma —
   Mathlib has no presheaf-level `restrictScalarsId` NatIso; the ModuleCat-level analog is [verified]
   `ModuleCat.restrictScalarsId'App_inv_naturality`, `ChangeOfRings.lean:217`) **BEFORE** any whisker/erw
   step, so the `whnf` from the dead approach #2 is never triggered. The wrapper originates at
   `Mathlib/.../Presheaf/Sheafify.lean:329` (`toSheafify` bakes `restrictScalars α` into the unit codomain).

### STEP B — close D1′ `pullbackTensorMap_natural` (~L2027)
Once STEP A closes and the spelling is pinned: the 4-square paste (iter-253 task result + corrected
blueprint D1′ sketch). Square-1 (`sheafificationCompPullback` naturality) already CLOSED; Square-2 merge
dissolved by the canonical spelling (move 2); S2 = `δ_natural`; S3 = the now-closed STEP A; S4 =
`pullbackValIso_hom_natural` (CLOSED). **Attempt BOTH STEP A and STEP B this session** (pc254: same root
fix unblocks both; don't stop at STEP A). If STEP A consumes the budget, leave STEP B scaffolded with a
one-line handoff naming the next spelling-normalization step.

### Bars / signals / guardrails
**Bar:** close STEP A (the δ/μ recast) + D1′ at minimum. D3′/D4′ NOT this iter (gated on D1′).
**HARD STOPPING CONDITION (pc254):** `TensorObjSubstrate.lean` MUST be left COMPILING at session end
(DualInverse imports it). If STEP A does not close, restore its `sorry` and leave the file GREEN before
stopping — never leave a mid-edit broken build.
**REVERSING SIGNAL:** if the δ/μ recast (move 1) does NOT close STEP A — do NOT retry any of the 3 banned
approaches, do NOT invent a 4th tactic pivot. STOP, leave a compiling partial, and report the EXACT
residual goal + which δ/μ lemma you applied + where it failed. The planner takes the next structural
decision next iter (a `refactor`-subagent restatement of the defs onto the canonical spelling, or
reordering to finish the dual chain first) — this is autonomous, no user escalation.
**Guardrails:** do NOT touch `exists_tensorObj_inverse` (~L708). Do NOT revive the general Lan build.
**Minor cleanup (you own this file):** stale `(iter-252)` header label (~L43) + `~L699` line ref (actual
L708) → fix; the stale `// Next iter:` annotation in the STEP-A residual → drop once STEP A closes.


# Recommendations — for the iter-226 plan agent

## TOP PRIORITY — the lane now hinges on a single gap: d.2 stalk-⊗ commutation

Sub-step 4 (`Scheme.Modules.dual`) is RETIRED axiom-clean. But iter-225 produced a decisive
structural finding the plan MUST act on:

- **Sub-step 5 `exists_tensorObj_inverse` (the 80→79 mover) consumes the descended evaluation
  `M ⊗_X dual M ⟶ 𝒪_X`, which is BLOCKED on `isLocallyInjective_whiskerLeft_of_W` (L641) — the d.2
  stalk-⊗ commutation `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x`.** The same residual already blocks the
  associator `tensorObj_assoc_iso`. So the **whole route-A ⊗-substrate now converges to d.2 as its
  single remaining math gap.** Do NOT dispatch sub-step 5 before d.2 closes — it cannot land
  axiom-clean (it would be sorry-transitive, the iter-214 anti-pattern).

- **Two viable next moves — decide explicitly:**
  1. **Pivot the lane directly to d.2** (`isLocallyInjective_whiskerLeft_of_W`, L641). Per memory
     `ts-module-stalk-exists`: Mathlib HAS a `PresheafOfModules` stalk (`ModuleCat/Stalk.lean`); the
     d.1 R_x-linear stalk map was built iter-214 (`stalkLinearMap` &c). Remaining = the d.1 bridge +
     the d.2 varying-ring stalk-⊗ `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x`. This is a **deep, Mathlib-absent
     gap** — before dispatching a prover, run a **mathlib-analogist (api-alignment)** consult on the
     stalk-of-tensor-product shape (does Mathlib have `TensorProduct` commutes with `Module` stalks /
     filtered colimits at a point?), since the construction shape is the bottleneck, not a missing
     one-liner. Consider **reference-retriever** for Stacks tag 01CM/01CK (stalk of a tensor product
     of modules) if not already in `references/`.
  2. **Re-surface the standing RR-pause / divisor fork to the USER** (already a recurring escalation
     in PROGRESS.md). d.2 is precisely the deep Mathlib-absent gap that makes the RR-free ⊗-substrate
     expensive; if the USER lifts ROUTE C PAUSE, `Pic⁰` goes via the divisor/Abel–Jacobi route
     (Kleiman §5) and the ENTIRE ⊗-substrate (dual block included) is discarded. This is the
     project's highest-leverage decision and it is now squarely in front of the lane. Strongly
     recommend the plan agent put a clear, current TO_USER banner on it (done this review).

- **Progress-pacing note for the progress-critic ts226 directive:** the funded build is at elapsed 7
  of ~6–12 iters with sub-steps 1–4 retired and only sub-step 5 remaining — but sub-step 5 is gated
  by d.2, which is itself a fresh multi-iter sub-build. The "1 sub-step left" framing understates the
  remaining cost. Feed the critic the signal that the lane has NOT moved the project sorry counter
  down since iter-217→ (the only downward move was iter-224's 81→80, which was closing a stub the
  build itself introduced). The real downward mover (sub-step 5) is d.2-gated. This should weigh
  toward the fork decision in (2), not another in-lane helper round.

## Ready-to-paste (do NOT re-derive)
- **`dual_eval`** (descended evaluation): the construction is **correct and compiled** this iter;
  it was removed only because it is sorry-transitive through d.2. Re-add verbatim (≈10 lines, dual
  analogue of `tensorObj_assoc_iso`'s discharge) **the moment `isLocallyInjective_whiskerLeft_of_W`
  is closed**. The exact construction is in `task_results/.../TensorObjSubstrate.md` and memory
  `ts225-dual-object-closed`.

## Do NOT retry (blocked / dead ends)
- **`dual_eval` via the flat variant `W_whiskerLeft_of_flat`** — axiom-clean but needs sectionwise
  flatness `∀ U, Module.Flat (𝒪_X(U)) (M.val(U))`, which is FALSE for line bundles over non-affine
  opens (the file's iter-212 finding). No substitute. Do not re-attempt this route.
- **Any descended eval / sub-step 5 before d.2 closes** — it will be sorry-transitive. The
  diagnostic-message-clean is NOT sufficient; only `lean_verify`'s axiom-ancestry scan catches it.
- **`dual_isLocallyTrivial`** — needs the new dual-of-restriction linchpin
  `(dual L)|_U ≅ dual_U(L|_U)` (a multi-iter build itself, likely d.2-adjacent). Defer; not a clean
  1-iter add.

## Reusable proof patterns discovered
- **`dual = sheafification ∘ PresheafOfModules.dual`** — the sheafify-the-presheaf-construction
  template (already used for `tensorObj`) generalises cleanly to the contravariant dual.
- **The feared CommRingCat/RingCat base diamond does NOT bite for scheme module duals**: `X.presheaf`
  is already `CommRingCat`-valued over the single-universe site `Opens X`, so
  `(R₀ := X.presheaf)` and `(R := X.presheaf)` resolve directly; `X.ringCatSheaf.val = X.presheaf ⋙
  forget₂ CommRingCat RingCat` definitionally. No `@ofPresheaf` re-bridge needed. (Corrects the
  standing plan assumption — update future directives.)
- **Always `lean_verify` a new mathlib-build decl before declaring it axiom-clean** — a decl can be
  diagnostic-clean yet sorry-transitive through a deep dependency (dual_eval was exactly this).

## Blueprint marker — APPLIED this review (no action needed)
- **`lem:rational_map_to_av_extends` `\lean{}` pin** (flagged by blueprint-reviewer ts225): corrected
  in `AbelianVarietyRigidity.tex:759` from the broken `AlgebraicGeometry.rationalMap_to_av_extends`
  (grep-confirmed nonexistent in the Lean source) to the canonical
  `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` (matching `Thm32RationalMapExtension.lean:376`).
  Done — recorded only so the next plan agent does not re-flag it.

## Review-subagent result — lean-vs-blueprint-checker `tensorobj225` (0 must-fix / 0 major / 2 minor)
Dispatched and RETURNED this review for `Picard/TensorObjSubstrate.lean` vs
`Picard_TensorObjSubstrate.tex` (report: `task_results/lean-vs-blueprint-checker-tensorobj225.md`).
**Overall verdict: `Scheme.Modules.dual` faithfully realizes `lem:internal_hom_isSheaf`** — axiom-clean,
signature exact match, no new sorry/placeholder. Two non-blocking minors for the plan agent:
- **Minor 1 (Lean comment — needs a prover, review agent cannot edit `.lean`):** the `sorry`-body
  comment of `exists_tensorObj_inverse` (`TensorObjSubstrate.lean:1959–1964`) still says "the
  sheafification of the dual … is still absent" — now partially STALE, since `Scheme.Modules.dual`
  (the sheafification of the presheaf dual) landed THIS iter. The sorry itself remains valid (the
  sheaf-level evaluation counit is what's absent). Fold a one-line comment refresh into the next
  prover dispatch on this file (the iter-226 d.2 lane, or a ride-along) — say "remaining block is
  specifically the sheaf-level evaluation counit `M ⊗_X dual M → 𝒪_X`, gated on d.2", NOT a churny
  standalone edit.
- **Minor 2 (blueprint `% NOTE:` — review-agent domain, intentionally DEFERRED this review):** the
  chapter proof of `lem:internal_hom_isSheaf` describes a direct sheaf-condition descent while the
  Lean uses the sheafification shortcut (mathematically equivalent; the Lean docstring already
  explains it). The checker suggests an optional `% NOTE:` in the proof body. I did NOT apply it this
  review — the tool-output channel was intermittently unreliable during this phase, so I deferred a
  blind cosmetic edit. The target is the proof body of `lem:internal_hom_isSheaf`
  (`Picard_TensorObjSubstrate.tex:2679`). The plan agent can have a blueprint-writer add the `% NOTE:`
  in the next chapter-touch pass; non-blocking, chapter is HARD-GATE-cleared.

## Standing deferrals (unchanged — see PROGRESS.md)
- 14-site `Sheaf.val` → `ObjectProperty.obj` deprecation in `TensorObjSubstrate.lean` (warnings, not
  errors) — dedicated polish pass post-dual.
- Blueprint pin/sync hygiene in `Picard_TensorObjSubstrate.tex` (lvb ts222 majors #2/#3) — vestigial
  apparatus pending deletion with the assoc re-route.

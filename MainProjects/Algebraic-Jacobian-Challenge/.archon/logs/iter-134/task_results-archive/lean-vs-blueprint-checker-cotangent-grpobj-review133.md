# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review133

## Iteration
133

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean` (297 lines, 3 declarations)
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` § Piece (i.a) (lines 92–280 + Iter-131 body-shape paragraph at lines 484–497)

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (chapter: `\lem:GrpObj_cotangentSpace`, lines 92–122)
- **Lean target exists**: yes — `noncomputable def cotangentSpaceAtIdentity` at line 161.
- **Signature matches**: yes — blueprint stub (lines 100–102) and Lean line 161–164 agree verbatim:
  `(G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k`.
- **Proof follows sketch**: yes — body is the iter-131 pure-term `noncomputable def`. The four-stage proof prose at blueprint lines 115–119 (identity-section → chart extraction via `smooth_locally_free_omega` → `ψV` construction → base-change) is realised in the body by:
  - `ηleft`, `x₀` (lines 166–168) ↔ blueprint step 1–2;
  - `h.choose` chain extracting `U, V, e, hxV` (lines 174–180) ↔ blueprint step 3 + iter-131 caveat (lines 120–121);
  - `htop`, `ψV` (lines 183–189) ↔ blueprint step 4;
  - outer `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])` (lines 199–200) ↔ blueprint formula (line 117) and iter-131 outer-head-symbol guarantee (line 121, lines 484–488).
- **notes**: body shape (`extendScalars` head, no top-level `Classical.choice`) matches the iter-131 body-shape contract documented at blueprint lines 484–488.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}` (chapter: `\lem:GrpObj_cotangentSpace_extendScalars_witness`, lines 124–160)
- **Lean target exists**: yes — `theorem cotangentSpaceAtIdentity_eq_extendScalars` at line 210.
- **Signature matches**: yes — blueprint stub (lines 134–147) and Lean lines 210–222 are verbatim identical (the iter-133 MED-B absorption landed a full `\lean{...}` signature stub matching the Lean theorem exactly).
- **Proof follows sketch**: yes — blueprint prose at lines 156–159 prescribes (a) reproduce the body's `Classical.choose`-chain, (b) derive `htop` via `Subsingleton.elim` on `Spec k`, (c) close the equation by `rfl`. Lean lines 223–231 do exactly this: `let` chain for `ηleft, x₀, h, hxV`; `refine ⟨h.choose, h.choose_spec.choose, h.choose_spec.choose_spec.choose, fun s _ => ?_, rfl⟩` (the trailing `rfl` discharges the equation); inner `change`/`rw [Subsingleton.elim …]`/`exact hxV` discharges `htop`.
- **notes**: iter-132 MED-B (missing `\lean{...}` block) is fully absorbed iter-133; this lemma is now a first-class blueprint citizen in the dependency graph.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (chapter: `\lem:GrpObj_lieAlgebra_finrank`, lines 218–280)
- **Lean target exists**: yes — `theorem cotangentSpaceAtIdentity_finrank_eq` at line 256.
- **Signature matches**: yes — blueprint stub (lines 225–228) and Lean lines 256–259 agree:
  `Module.finrank k (cotangentSpaceAtIdentity (n := n) G) = n`.
- **Proof follows sketch**: yes — blueprint Steps 1+2 (live closure path, lines 244–265) prescribe (Step 1) re-extract `hfree, hrank` from `smooth_locally_free_omega`'s existential, convert `hrank` to `finrank` via `Module.finrank_eq_of_rank_eq`; (Step 2) apply `Module.finrank_baseChange`. Lean lines 260–294 do exactly this:
  - lines 261–267: `let`-chain re-extracts `U, V, e, hxV` (matches iter-131 body);
  - lines 269–275: `algGV`, `hfree`, `hrank` from the `.choose_spec` payload;
  - lines 277–284: reconstruct `htop, ψV, algGVk, Nontrivial Γ(G, V)`;
  - lines 288–289: `change Module.finrank k (TensorProduct …) = n` (the iter-132 direct `change`-based route documented at blueprint lines 484–495, item 1);
  - lines 291–292: `rw [Module.finrank_baseChange …]`;
  - line 294: `exact Module.finrank_eq_of_rank_eq hrank`.
- **notes**: Steps 3 (deferred alternative via `\lem:GrpObj_cotangent_bridge`) and 4 (dualisation conclusion) in the blueprint are explicitly off the live path; the Lean proof correctly closes only the live Steps 1+2 portion.

## Red flags

(No findings.)

- No `sorry` in any of the three declarations.
- No suspect bodies (no `:= True`, no `:= rfl` on a non-trivial claim, no top-level `Classical.choice` — iter-131 body shape contract preserved).
- No `axiom` declarations.
- No "TODO replace with real def", "temporary", "wrong but works for now" excuse-comments. The "Caveat on canonicity" docstring at lines 137–152 is a legitimate mathematical disclosure (chart-dependence of the body), not an excuse-comment; the blueprint discloses the same caveat at lines 120–121.
- Axioms (`propext`, `Classical.choice`, `Quot.sound`) are the standard three; `Classical.choice` is consumed exactly as the blueprint authorises (via the `\notready` `Classical.choose`-chain on `smooth_locally_free_omega`, blueprint line 121).
- `lean_verify` warnings on lines 50/53/204 trigger on the word "opaque" appearing inside the file's docstring prose (describing the iter-130 opacity defect that iter-131 fixed); no actual `opaque` declarations exist in the file.

## Unreferenced declarations (informational)

None. All three Lean declarations (`cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_eq_extendScalars`, `cotangentSpaceAtIdentity_finrank_eq`) have corresponding `\lean{...}` blocks in `RigidityKbar.tex` § Piece (i.a).

## Blueprint adequacy for this file

- **Coverage**: 3 / 3 Lean declarations have a corresponding `\lean{...}` block. Iter-133 added the missing block for `cotangentSpaceAtIdentity_eq_extendScalars` (iter-132 MED-B), bringing coverage to 100%.
- **Proof-sketch depth**: adequate. Each Lean proof body is a faithful realisation of the blueprint's `\begin{proof}` sketch:
  - `cotangentSpaceAtIdentity` body ↔ blueprint lines 115–121 (4-step Replacement-(B) construction + iter-131 body-shape contract at lines 484–488);
  - `cotangentSpaceAtIdentity_eq_extendScalars` proof ↔ blueprint lines 156–159 (3-step `Classical.choose`-chain reproduction + `Subsingleton.elim` + `rfl`);
  - `cotangentSpaceAtIdentity_finrank_eq` proof ↔ blueprint Steps 1+2 at lines 244–265 (chart-side Kähler rank + `finrank_baseChange`), with the direct `change`-based route explicitly chosen and documented at blueprint lines 484–495 item 1.
  The iter-132 MED-C (rewrite-pattern paragraph drift) is fully absorbed: the "Iter-131 `Classical.choose`-chain body shape" paragraph (lines 484–497) now enumerates both the direct `change`-based route (item 1, used by the iter-132 closure) and the `obtain`+`rw [heq]` route (item 2, alternative), and explicitly cross-references the iter-132 closure body shape.
- **Hint precision**: precise. All `\lean{...}` blocks pin a unique fully-qualified declaration name. Signature stubs in the blueprint comments match the Lean signatures verbatim (relative-dimension `n` parameter via `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`, etc.).
- **Generality**: matches need. The blueprint pins the free-`n` `[SmoothOfRelativeDimension n G.hom]` binder (vs. the iter-128 hardcoded `n = 1`); the Lean side matches.
- **Recommended chapter-side actions**: none required for this iteration. The new helper sub-lemmas added iter-133 (`lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_restrict_to_identity_section`) and the hardened `lem:GrpObj_mulRight_globalises` are all correctly marked `\notready`; their underlying Lean declarations do not yet exist (deliberately deferred to iter-134+) and the blueprint correctly does not claim Lean coverage. The blueprint chapter file `AlgebraicJacobian_Cotangent_GrpObj.tex` does not exist — per the directive, slug-mapping is intentionally `Cotangent/GrpObj.lean → RigidityKbar.tex` § Piece (i), not flagged.

### Minor: line-number drift in blueprint cross-references (informational, non-blocking)

The blueprint contains two stale Lean line-number references that drifted as the docstring sections of `GrpObj.lean` grew:

1. Blueprint line 159 says the proof of `lem:GrpObj_cotangentSpace_extendScalars_witness` is "closed at `AlgebraicJacobian/Cotangent/GrpObj.lean:198--219`". Actual location: lines 210–231 (the theorem statement starts at line 210; proof closes at line 231).
2. Blueprint line 493 says the iter-132 rank-lemma closure uses a "direct `change …` step" at "`AlgebraicJacobian/Cotangent/GrpObj.lean:276--282`". Actual location: lines 285–294 (`change` at lines 288–289; closure block at 285–294).

Both drifts are <15 lines and do not affect mathematical correctness or the reviewer's ability to locate the referenced code. Recommend a low-priority refresh in the next blueprint-writer pass, but does not block iter-133.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - Blueprint line-number drift in two cross-references (lines 159 and 493 of `RigidityKbar.tex`) — see "Minor" section above. Easy refresh in a future blueprint-writer pass.

Overall verdict: PASS — the Lean file faithfully realises the blueprint's iter-131 + iter-132 Piece (i.a) prose contract; iter-132 MED-B and MED-C are fully absorbed; the new iter-133 `\notready` helper-lemma blocks and the hardened `lem:GrpObj_mulRight_globalises` correctly describe iter-134+ deferred work (not flagged per directive); only minor cosmetic blueprint line-number drift remains.

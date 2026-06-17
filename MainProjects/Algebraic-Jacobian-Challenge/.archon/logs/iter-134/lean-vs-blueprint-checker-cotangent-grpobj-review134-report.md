# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review134

## Iteration
134

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean` (574 LOC)
- Blueprint (authoritative): `blueprint/src/chapters/RigidityKbar.tex` (518 LOC) — § "Piece (i)"
- Blueprint (per-file pointer, briefly reviewed): `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` (45 LOC)

The Lean file has 10 declarations total: 3 substantive `cotangentSpaceAtIdentity` decls (closed iter-128→132), the iter-134 substantive `shearMulRight` triple (`shearMulRight` + two `@[simps]` companions `shearMulRight_hom_fst/snd`), the iter-134 packaging helper `schemeHomRingCompatibility`, and 3 iter-134 PLACEHOLDER theorems (`relativeDifferentialsPresheaf_basechange_along_proj_two`, `relativeDifferentialsPresheaf_restrict_along_identity_section`, `mulRight_globalises_cotangent`).

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (`lem:GrpObj_cotangentSpace`)
- **Lean target exists**: yes (line 161).
- **Signature matches**: yes — `noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k))) [GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k` matches the blueprint's pinned signature stub at lines 100–102 verbatim.
- **Proof follows sketch**: yes — body realises Replacement (B) (`Classical.choose`-chain on `smooth_locally_free_omega` → `ModuleCat.extendScalars` of the chart-level Kähler module) exactly as the blueprint's `\begin{proof}` (lines 115–122) describes.
- **notes**: out of scope this iter — closed iter-128 → iter-131 body refactor. Caveat-on-canonicity disclosure is consistent on both sides.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}` (`lem:GrpObj_cotangentSpace_extendScalars_witness`)
- **Lean target exists**: yes (line 210).
- **Signature matches**: yes — matches the blueprint's pinned signature stub at lines 134–147 verbatim.
- **Proof follows sketch**: yes — body reproduces the `Classical.choose`-chain on `smooth_locally_free_omega`, closes the top-inclusion via `Subsingleton.elim`, and discharges the displayed equation by `rfl`. Matches blueprint proof at lines 158–159.
- **notes**: out of scope this iter — closed iter-131.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (`lem:GrpObj_lieAlgebra_finrank`)
- **Lean target exists**: yes (line 256).
- **Signature matches**: yes — matches the blueprint's pinned signature stub at lines 225–228 verbatim.
- **Proof follows sketch**: yes — body executes the blueprint Steps 1 + 2 (chart-side Kähler rank from `smooth_locally_free_omega`'s existential, `Module.finrank_eq_of_rank_eq`, then `Module.finrank_baseChange`) and uses the recommended `change`-based unification with the underlying `TensorProduct` carrier described at blueprint lines 496–497.
- **notes**: out of scope this iter — closed iter-132.

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` (`lem:GrpObj_omega_basechange_proj`)
- **Lean target exists**: yes (line 476).
- **Signature matches**: **no** — Lean has `Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅ Scheme.relativeDifferentialsPresheaf G.hom)`. Blueprint claims `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` on `(G ⊗ G).left` (i.e. a different LHS scheme indexed by `pr_1`, and a `PresheafOfModules.pullback (φ_pr_two G)` on the RHS). The actual delivered type is the reflexive tautology `X ≅ X` with `X = relativeDifferentialsPresheaf G.hom`.
- **Proof follows sketch**: no — body is `⟨Iso.refl _⟩`. None of the blueprint's chained-`tensorKaehlerEquiv` + `TopCat.Presheaf.pullback` argument is in the Lean body.
- **notes**: blueprint statement carries `\notready` (line 401); iter-134 docstring (lines 449–475) explicitly labels this an "Iter-134 placeholder" with the intended type spelled out. The blueprint's proof block has `\leanok` on line 411 — this `\leanok` is technically consistent with the placeholder body's `⟨Iso.refl _⟩` (no `sorry`), but semantically misleading because the closed "proof" matches a tautology, not the intended statement. See severity note below.

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (`lem:GrpObj_omega_restrict_to_identity_section`)
- **Lean target exists**: yes (line 508).
- **Signature matches**: **no** — same shape problem. Lean has `Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅ Scheme.relativeDifferentialsPresheaf G.hom)`. Blueprint claims `s^*(pr_2^* Ω_{G/k}) ≅ π_G^*(η_G^* Ω_{G/k})` on `G` (two nested `PresheafOfModules.pullback`s on each side of the iso).
- **Proof follows sketch**: no — body is `⟨Iso.refl _⟩`.
- **notes**: blueprint statement carries `\notready` (line 443); docstring (lines 484–514) labels this an "Iter-134 placeholder" with intended type spelled out. `\leanok` on proof (line 452) is again technically-consistent but misleading.

### `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (`lem:GrpObj_mulRight_globalises`)
- **Lean target exists**: yes (line 566).
- **Signature matches**: **no** — Lean has `Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅ Scheme.relativeDifferentialsPresheaf G.hom)`. Blueprint claims `Ω_{G/k} ≅ π_G^*(η_G^* Ω_{G/k})` (the RHS is `(PresheafOfModules.pullback φ_str).obj ((PresheafOfModules.pullback φ_η).obj (relativeDifferentialsPresheaf G.hom))`, per the explicit stub at blueprint lines 298–305).
- **Proof follows sketch**: no — Lean body is `⟨Iso.refl _⟩`. Blueprint proof outline names Step 1 (shear iso, closed substantively as `shearMulRight`), Step 2 (`lem:GrpObj_omega_basechange_proj`, placeholder), Step 3 (`lem:GrpObj_omega_restrict_to_identity_section`, placeholder), and Compose. Only Step 1 has real Lean content; the Compose step is absent.
- **notes**: blueprint statement carries `\notready` (line 323); the iter-134 docstring (lines 516–565) explicitly labels this an "Iter-134 placeholder" with intended type spelled out. `\leanok` on proof (line 343) — same misleading-but-technically-consistent issue.

## Red flags

### Placeholder / suspect bodies

- **`relativeDifferentialsPresheaf_basechange_along_proj_two` at line 476**: body `⟨Iso.refl _⟩`. The type elaborates to `Nonempty (X ≅ X)`, which is trivially inhabited and *structurally unrelated* to the blueprint's claimed `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}`. Per the rubric this is a "weakened-wrong definition: Lean defines a structurally-different stand-in" — the standard `must-fix-this-iter` classifier.
- **`relativeDifferentialsPresheaf_restrict_along_identity_section` at line 508**: same pattern; body `⟨Iso.refl _⟩` on tautological `X ≅ X` type while the blueprint's `lem:GrpObj_omega_restrict_to_identity_section` claims `s^*(pr_2^* Ω_{G/k}) ≅ π_G^*(η_G^* Ω_{G/k})`.
- **`mulRight_globalises_cotangent` at line 566**: same pattern; body `⟨Iso.refl _⟩` on tautological `X ≅ X` while the blueprint claims the main globalisation iso `Ω_{G/k} ≅ π_G^*(η_G^* Ω_{G/k})`.

**Mitigating context** (per directive question 1, requesting an explicit verdict on whether `\notready` + docstring disclosure suffices):

1. All three blueprint statement blocks carry `\notready`. By the project's marker vocabulary (`.archon/CLAUDE.md`, "Blueprint Marker Vocabulary"), `\notready` signals "block is unformalized; failed-translation annotation acceptable." That marker is **specifically** the vehicle for "the Lean target is a stand-in pending real formalization."
2. The Lean docstrings explicitly state the intended type, mark the body as a placeholder, and document the multi-iter NEEDS_MATHLIB_GAP_FILL closure path. They are not deceiving anyone.
3. The iter-134 plan-agent pre-commitment (recorded in the directive) and the iter-133 mathlib-analogist verdict (recorded in `analogies/mulright-globalises-cotangent.md`) explicitly authorize the placeholder pattern.

**My verdict**: the rubric's strict classification is *signature mismatch + structurally-different stand-in = must-fix-this-iter*. The disclosure is conscientious but doesn't change the rubric. However, the project-internal convention of `\notready` + placeholder + docstring intended-type is in active use for multi-iter Mathlib-gap work and is recognised by the plan agent. I report this as **must-fix-this-iter under the strict rubric**, but flag the **placeholder convention itself as a project-level methodology question** for the plan agent: either (a) the convention is acceptable and the rubric should be tightened to exempt `\notready` + docstring-disclosed placeholders, or (b) the convention should be retired in favour of writing the intended signature with a `sorry` body. The current setup gets the worst of both worlds — tautological types that elaborate without sorry, leaving zero downstream type-level signal that the work is incomplete.

### Excuse-comments

- **GrpObj.lean:424, 429, 437**: section docstring at lines 421–447 explicitly frames the three placeholder theorems as "placeholders pending the multi-iter piece (i.b) lane closure" and describes the iter-134 placeholder pattern as a working substitute for the intended signature. By the strict rubric, "comments excusing wrong/incomplete code: `-- placeholder`, `-- temporary`" trigger must-fix. These are not "wrong but works for now" excuse-comments in the usual sense — they document a scheduled multi-iter strategy — but the rubric does not distinguish.
- **GrpObj.lean:473, 504, 561–562**: individual-declaration docstrings each say "Iter-134 placeholder: reflexive iso Ω_{G/k} ≅ Ω_{G/k}. The next iter is expected to…". Same classification.

These are inseparable from the placeholder body finding above; if the bodies stand, the disclosure comments should stand with them.

### Axioms / `Classical.choice` on non-trivial claims

- No `axiom` declarations introduced in this file.
- `Classical.choose` / `Classical.choose_spec` are used in `cotangentSpaceAtIdentity` and `cotangentSpaceAtIdentity_finrank_eq` — blueprint authorises this (Caveat on canonicity at lines 121, 244–247; iter-131 Classical.choose-chain note at lines 488–499). Not a new finding.
- No suspect `:= rfl` / `:= True` on substantive declarations beyond the three `⟨Iso.refl _⟩` placeholders already flagged.

## Unreferenced declarations (informational)

| Lean declaration | Line | Comment |
|---|---|---|
| `shearMulRight` | 349 | **Substantive iter-134 close** (~30 LOC of `lift_lift_assoc` / `lift_comp_inv_*` calculus). Not individually `\lean{...}`-referenced. The blueprint mentions it descriptively in the proof of `lem:GrpObj_mulRight_globalises` Step 1 (lines 344–352, "$\sigma_{\mathrm{hom}}$ := lift (fst G G) μ"), and the auxiliary chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` lists it (lines 24–28). Per the rubric this is a **missing `\lean{...}` reference** — `major` because a substantive declaration of this size with a NEEDS_MATHLIB_GAP_FILL designation merits its own blueprint block in `RigidityKbar.tex`. Recommendation: blueprint-writer adds a `\begin{lemma}\label{lem:GrpObj_shearMulRight}\lean{AlgebraicGeometry.GrpObj.shearMulRight}` block isolating Step 1 of the proof of `lem:GrpObj_mulRight_globalises` next iter. |
| `shearMulRight_hom_fst` | 386 | `@[simps]`-spawned companion. Conventional — no separate blueprint block expected. |
| `shearMulRight_hom_snd` | 391 | `@[simps]`-spawned companion. Conventional — no separate blueprint block expected. |
| `schemeHomRingCompatibility` | 417 | Packaging helper around `((adj).homEquiv _ _).symm f.c`. Genuinely structural (no mathematical content), so unreferenced helper is acceptable. Worth a one-line mention in the auxiliary chapter though (currently omitted). |

## Blueprint adequacy for this file

- **Coverage**: 6/10 Lean declarations have a corresponding `\lean{...}` block in `RigidityKbar.tex`. The 4 unreferenced are: `shearMulRight` (substantive — flagged above), the two `@[simps]` companions (conventional, no flag), and `schemeHomRingCompatibility` (helper, minor flag for auxiliary-chapter omission).
- **Proof-sketch depth**: **adequate**. Per directive question 4: the blueprint's hardening of `lem:GrpObj_mulRight_globalises` (lines 282–370), `lem:GrpObj_omega_basechange_proj` (lines 372–419), and `lem:GrpObj_omega_restrict_to_identity_section` (lines 421–454) names the relevant Mathlib idioms precisely (`KaehlerDifferential.tensorKaehlerEquiv` from `Mathlib.RingTheory.Kaehler.TensorProduct`, `PresheafOfModules.pullback`/`pullbackComp`/`pullbackId` from `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`, `TopCat.Presheaf.pullback` from `Mathlib.Topology.Sheaves.Pullback`). Per-step LOC envelopes (~150–300 for Step 2, ~30–80 for Step 3) and the load-bearing-vs-bookkeeping decomposition are explicit. A prover entering iter-135+ with this chapter can scope each helper independently.
- **Hint precision**: **precise** for the three placeholder lemmas — each has a full Lean-signature-stub comment (lines 298–305, 384–399, 427–441) showing the intended `PresheafOfModules.pullback (φ_…)`-based RHS. The four `φ_*` compatibility morphisms (`φ_str`, `φ_η`, `φ_pr_two`, `φ_section`) are described conceptually but the blueprint does *not* commit to whether they should be in-file helpers, in `AlgebraicJacobian/Differentials.lean`, or upstream as Mathlib contributions. **Minor** gap: a sentence pinning the `φ_*` home would help next iter.
- **Generality**: **matches need**. The presheaf-of-modules level RHS (sheaf-level, not sheafified) is the right level per the iter-133 mathlib-analogist Decision 4 and is what the rest of the project expects.
- **Recommended chapter-side actions**:
  - **(major)** Add a `\begin{lemma}\label{lem:GrpObj_shearMulRight}\lean{AlgebraicGeometry.GrpObj.shearMulRight}` block in `RigidityKbar.tex` isolating Step 1 of `lem:GrpObj_mulRight_globalises`; the declaration is substantive (~30 LOC of `lift_lift_assoc`/`lift_comp_inv_*` calculus) and a NEEDS_MATHLIB_GAP_FILL contribution candidate.
  - **(minor)** Add `schemeHomRingCompatibility` to the auxiliary chapter's bulleted list (`AlgebraicJacobian_Cotangent_GrpObj.tex` line 12–42) — currently absent.
  - **(minor)** Add a sentence to the proof of `lem:GrpObj_mulRight_globalises` pinning where the four `φ_*` compatibility morphisms should live (in-file helper, `Differentials.lean`, or upstream Mathlib).
  - **(methodology, advisory)** Decide whether the `\notready` + tautological-placeholder + docstring-intended-type pattern (used in this iter for the three Step-2/3/Compose lemmas) is the project's standing convention for multi-iter Mathlib-gap work, or whether the intended-signature-with-`sorry` pattern is preferred. The current convention type-checks but emits zero machine-readable signal that the work is incomplete — `sorry_analyzer` cannot distinguish a placeholder iso from a real one.

### On the auxiliary chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` (directive question 5)

Briefly reviewed (45 LOC pointer-only chapter). Claims to list 7 Lean declarations (correct: numbered items 1–7 cover the seven non-`@[simps]`-companion declarations). The two `@[simps]`-spawned `shearMulRight_hom_fst`/`shearMulRight_hom_snd` are not listed — conventional and fine. `schemeHomRingCompatibility` is NOT listed — minor omission, noted above. The chapter's framing as a pointer to `RigidityKbar.tex` § "Piece (i)" is accurate. No substantive issue.

## Severity summary

- **must-fix-this-iter**:
  - **(strict rubric)** Three trivially-true tautological bodies (`⟨Iso.refl _⟩` on type `Nonempty (X ≅ X)`) standing in for substantive blueprint claims, at lines 476, 508, 566 (declarations `relativeDifferentialsPresheaf_basechange_along_proj_two`, `relativeDifferentialsPresheaf_restrict_along_identity_section`, `mulRight_globalises_cotangent`). Per the rubric's exact wording: "weakened-wrong definitions: Lean defines a structurally-different stand-in" and "signature mismatch with the blueprint's prose."
  - **(advisory carve-out)** These placeholders were explicitly pre-committed by the iter-134 plan agent and the blueprint blocks are marked `\notready`. The plan agent has *full knowledge* — this is not a hidden critical finding. If the plan agent confirms that `\notready`-marked placeholder bodies are an accepted project convention for multi-iter Mathlib-gap work, then the rubric is the thing that needs sharpening, not the Lean file. I report under the strict rubric per the lean-vs-blueprint-checker instructions ("Do NOT under-classify to soften the blow") and defer the convention question to the plan agent.

- **major**:
  - `shearMulRight` (substantive iter-134 declaration, ~30 LOC) is not `\lean{...}`-referenced in `RigidityKbar.tex`. The auxiliary chapter lists it but the main mathematical chapter does not. Recommend a new lemma block isolating it.

- **minor**:
  - `schemeHomRingCompatibility` omitted from auxiliary chapter's bulleted list.
  - Blueprint does not pin the home file for the four `φ_*` compatibility morphisms used in the placeholder bodies' intended types.

- **out of scope** (per directive Known Issues): stale Lean-line anchors at lines 28/30/31–32 of the Lean docstring; stale `RigidityKbar.tex` line citations at lines 159 + 493; both carried from iter-133, iter-135 cleanup scheduled.

**Overall verdict**: under the strict rubric, three must-fix-this-iter placeholder/signature-mismatch findings, but each is fully disclosed (Lean docstrings + blueprint `\notready` + iter-134 plan-agent pre-commitment), so the plan agent should treat this as a *convention-vs-rubric* judgment call rather than a hidden defect; the substantive iter-134 work (`shearMulRight` triple + `schemeHomRingCompatibility` helper + `cotangentSpaceAtIdentity*` carryover) is correctly signed and proofs match their blueprint sketches.

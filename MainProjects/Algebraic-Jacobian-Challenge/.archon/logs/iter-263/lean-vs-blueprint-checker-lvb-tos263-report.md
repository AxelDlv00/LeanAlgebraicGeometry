# Lean ↔ Blueprint Check Report

## Slug
lvb-tos263

## Iteration
263

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (2756 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (~4400 lines)

---

## Directive-specific questions

### (a) Does the chapter's Sq1 sketch describe the now-named residual `sheafificationCompPullback_comp_tail`?

**Partially — correct at high level, silent on the specific goal form.**

The blueprint's Sq1 paragraph (§ "Sq1 (sheafification ↔ pullback) — the sole open ingredient",
proof of `lem:pullback_tensor_map_basechange`) says:

> "transposing the identity under the composite adjunction for h∘f and evaluating the LHS by
> `homEquiv_leftAdjointUniq_hom_app` reduces it to a **unit-level identity**; the two `pullbackComp`
> factors are then transported across the adjunction units — the δ-free twin of
> `lem:pullbackObjUnitToUnit_comp`."

The "unit-level identity" and "transport the two pullbackComp factors" ARE the content of
`sheafificationCompPullback_comp_tail`. So the blueprint names the residual's **character** — it is a
composite-adjunction-unit coherence — and points to the right strategy ("δ-free twin of
`pullbackObjUnitToUnit_comp`").

**What the blueprint does NOT say:**

1. It does not separate the R0-peel step (now extracted as `sheaf_unit_comp_pushforward_pullbackComp_inv`,
   axiom-clean) from the tail. The blueprint describes Sq1 as one step from transpose to close; the Lean
   has split it into R0-peel + B-unit-tail. This decomposition is Lean-level engineering invisible to
   the blueprint.

2. It does not give the explicit goal form of the tail. The Lean proof comment (L2498–2518) gives the
   precise form: after R0-peel and the `← Functor.map_comp` merges, the goal is
   `B_{h≫f}.unit.app P = (sheafAdj_X.unit P ≫ (forget⋙restr).map (merged)) ≫ (forget⋙restr).map (R1 ≫ R5 ≫ a_Z.map δ_pre)`,
   where B_{h≫f} = (PrPbPushAdj φ'_{h≫f}).comp (sheafAdj_Z). The blueprint says only "unit-level
   identity" without giving this two-composite-adjunction form.

3. It does not describe the two-layer structure: B_f = (PrPbPushAdj φ'_f).comp sheafAdj_Z vs
   B_h = similar, with the `homEquiv_leftAdjointUniq_hom_app` application needed for both R1 and R5.

**Verdict:** YES in substance (the Sq1 residual is the B_{h≫f}.unit composite-adjunction-unit coherence,
and the blueprint correctly names the proof strategy). NO on specificity: the blueprint does not pin the
explicit goal form or distinguish the R0-peel from the tail.

---

### (b) Is the chapter adequate to guide closing `sheafificationCompPullback_comp_tail` and `pullbackTensorMap_restrict`?

**`sheafificationCompPullback_comp_tail` — UNDER-SPECIFIED.**

The blueprint's only guidance is: "δ-free twin of `pullbackObjUnitToUnit_comp`". For a prover already
expert in `pullbackObjUnitToUnit_comp`, this is actionable. But it omits:
- The specific goal form after R0-peel (what `B_{h≫f}.unit.app P` expands to and what the RHS merged
  argument looks like).
- The two-layer nature of the composite adjunctions B_f, B_h (each is a `presheafPullbackPushforward ⋙
  sheafificationAdj` composite; the reduction uses `homEquiv_leftAdjointUniq_hom_app` at TWO levels,
  one for `f` and one for `h`).
- The `hinner`/`hcomp'` chain analog (the specific route through `comp_unit_app` + `unit_naturality` +
  `pushforwardComp.hom.naturality` to reassemble `B_{h≫f}.unit`).
- LOC estimate or difficulty signal.

A prover reading only the blueprint would know to mirror `pullbackObjUnitToUnit_comp` but would need to
independently discover the exact goal form, the two-layer structure, and the merge strategy. The Lean
proof comment (L2498–2518) is far more detailed than the blueprint.

**`pullbackTensorMap_restrict` — ADEQUATE FOR THE 4-SQUARE STRUCTURE, thin on Sq4.**

The blueprint (proof of `lem:pullback_tensor_map_basechange`) correctly:
- Identifies all four squares (Sq1, Sq2, Sq2b, Sq3, Sq4) and their roles.
- Names Sq1 (`sheafificationCompPullback_comp`) as the open target.
- Describes Sq2b (`pullbackComp_δ` + `pushforwardComp_lax_μ`) as the δ-core, now CLOSED.
- Notes the interleaving/sliding issue (factors must be moved by δ_natural before paste).
- Correctly says Sq4 "becomes a short corollary once Sq1 is in hand" via the `pullbackValIso`
  factorisation.

But Sq4 is under-specified: the blueprint says it "reduces to that of Sq1 together with the
pseudofunctoriality of the counit" without giving an explicit statement for the `pullbackValIso`
composition coherence sub-lemma. Since Sq4 must be built as a standalone sub-lemma (it is not yet
in the file), the blueprint should state its goal explicitly.

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (def:scheme_modules_tensorobj)
- **Lean target exists**: yes
- **Signature matches**: yes — sheafification of `PresheafOfModules.Monoidal.tensorObj` on the small Zariski site
- **Proof follows sketch**: yes (no sorry)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (lem:scheme_modules_tensorobj_functoriality)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry)

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (def:scheme_modules_isinvertible)
- **Lean target exists**: yes (L194)
- **Signature matches**: yes — `∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: N/A (def)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (lem:tensorobj_restrict_iso)
- **Lean target exists**: yes (L451)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry; 4-step composite H1∘H2 route matching blueprint)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (lem:tensorobj_unit_iso)
- **Lean targets exist**: yes (L297, L307)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (lem:tensorobj_comm_iso)
- **Lean target exists**: yes (L317)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (lem:tensorobj_assoc_iso)
- **Lean target exists**: yes (L346)
- **Signature matches**: yes (unconditional, no locally-trivial hypothesis)
- **Proof follows sketch**: yes (no sorry, ROUTE (d) route matching blueprint)

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (lem:tensorobj_inverse_invertible)
- **Lean target exists**: yes (L698)
- **Signature matches**: yes — `∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ unit)`
- **Proof follows sketch**: partial — body is `sorry` (cross-file deferred to `DualInverse.lean`; body comment explains 2 remaining bridges, C and A)
- **notes**: Deliberate open sorry, explicitly documented; not misleading

### `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}` / `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` (thm:pic_commgroup / def:pic_carrier)
- **Lean targets exist**: yes (L792, L826)
- **Signature matches**: yes — `CommGroup (PicGroup X)` with by-hand group law
- **Proof follows sketch**: yes (no sorry; each group axiom closed by a single existence-of-iso)

### `\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}` (lem:unitToPushforwardObjUnit_comp)
- **Lean target exists**: yes (L874)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry; sectionwise `rfl` as described)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (lem:pullbackObjUnitToUnit_comp)
- **Lean target exists**: yes (L915)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry; adjunction-mate transport as described)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (lem:pullback_unit_iso)
- **Lean target exists**: yes (L1058)
- **Signature matches**: yes — all `f` by `final_of_representablyFlat`
- **Proof follows sketch**: yes (no sorry; iter-241 chart-chase-not-needed finding matches blueprint update)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (lem:pullback_tensor_map)
- **Lean target exists**: yes (L1218)
- **Signature matches**: yes — 4-fold composite map, no iso assertion
- **Proof follows sketch**: yes (no sorry)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (lem:pullback_tensor_map_natural) — D1′
- **Lean target exists**: yes (L2012)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry; axiom-clean, iter-255)

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_natural}` (lem:sheafify_tensor_unit_iso_natural)
- **Lean target exists**: yes (L1949)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry; iter-254 `tensorHom`-pin route)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackValIso_hom_natural}` (lem:pullback_val_iso_natural)
- **Lean target exists**: yes (L1914)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (lem:pullback_tensor_iso_unit) — D2′
- **Lean target exists**: yes (L1856)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry; iter-250 close via `pullbackEtaUnitSquare` chain)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackEtaUnitSquare}` (lem:eta_bridge_unit_square)
- **Lean target exists**: yes (L1758)
- **Signature matches**: yes
- **Proof follows sketch**: yes (no sorry)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (lem:pullback_tensor_map_basechange) — D3′
- **Lean target exists**: yes (L2652)
- **Signature matches**: yes — `pullbackTensorMap (h ≫ f) = pullbackComp.inv ≫ (pullback h).map (pullbackTensorMap f) ≫ pullbackTensorMap h ≫ tensorObjIsoOfIso(pullbackComp)(pullbackComp).hom`
- **Proof follows sketch**: partial — body is `sorry` at L2747; see Red flags
- **notes**: Outer `sorry` retained (iter-261+); gated on Sq1 (`sheafificationCompPullback_comp_tail`) + Sq4 (`pullbackValIso` composition coherence, not yet stated as a sub-lemma)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIsoOfLocallyTrivial}` (lem:pullback_tensor_iso_loctriv) — D4′
- **Lean target exists**: **NO** — declaration is not present in the Lean file (DAG: `"proved": false`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The blueprint has a `\lean{}` pin but no declaration exists yet. This is expected (D4' is gated on D3'/Sq1+Sq4); blueprint correctly has NO `\leanok` on this block.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` (referenced in `lean_decls`)
- **Lean target exists**: yes (L572)
- **Signature matches**: yes — stalkwise-iso criterion, axiom-clean
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (referenced in `lean_decls`)
- **Lean target exists**: yes (L222)
- **Signature matches**: yes — sheafification of `PresheafOfModules.dual`

### `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` (referenced in `lean_decls`)
- **Lean target exists**: yes (L233)
- **Signature matches**: yes

---

## Red flags

### Placeholder / suspect bodies

- `exists_tensorObj_inverse` at L720: body is `sorry`. Deliberately deferred to `DualInverse.lean` — body comment is thorough and specific (two named bridges C and A remain, route correctly described). The `sorry` is appropriately earmarked; not misleading.

- `sheafificationCompPullback_comp_tail` (private) at L2519: body is `sorry`. NEW in iter-263 — extracted from `sheafificationCompPullback_comp` to isolate the R1/R5/δ-collapse tail. Body comment (L2498–2518) gives the precise missing ingredient (composite-adjunction-unit coherence `B_{h≫f}.unit`) and a ~50–80 LOC LOC estimate. The extraction is an iter-263 engineering step; the sorry is the open target for iter-264.

- `pullbackTensorMap_restrict` at L2747: `sorry` retained. Gated on `sheafificationCompPullback_comp_tail` (Sq1) + the Sq4 `pullbackValIso` composition coherence (not yet stated as a sub-lemma). Body comment is thorough (L2661–2747). Expected open obligation.

### Excuse-comments
None. All sorry-related comments explain the mathematical reason and the route to closure; none say "wrong but will fix" or "placeholder".

### Axioms / Classical.choice on non-trivial claims
None introduced by the prover this iter. (`Classical.choice` appears in `picInv` via `Classical.choose` on the existential; this is correct and authorized by the blueprint's existential carrier design.)

---

## Unreferenced declarations (informational)

The following substantive public declarations are NOT in `lean_decls` / not `\lean{}`-pinned:

- `dualIsoOfIso` (L233) — public, substantive. Blueprint pins `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso` IS in `lean_decls` (line 328 of `blueprint/lean_decls`). ✓ covered.
- `restrictIsoUnitOfLE` (L399) — public helper, not in `lean_decls`. Used internally by `tensorObj_isLocallyTrivial`. Not a blueprint concern.
- `pullbackObjUnitToUnitIso` (L1041) — public, not in `lean_decls`. It is a derived bundled-iso helper wrapping `pullbackObjUnitToUnit`; the blueprint pins the underlying `pullbackObjUnitToUnit_comp`, not this wrapper. Minor.
- `homMk` (L613) — IS in `lean_decls` (line 336). ✓ covered.
- Private helpers (`sheaf_unit_comp_pushforward_pullbackComp_inv`, `sheafificationCompPullback_comp`, `sheafificationCompPullback_comp_tail`, `isIso_pbu_of_final`, etc.) — private, no pin needed.

---

## Blueprint adequacy for this file

- **Coverage**: 34/~38 substantive Lean declarations have a corresponding `\lean{...}` block. Missing pin: `pullbackTensorIsoOfLocallyTrivial` (declared in blueprint but not yet in the Lean file — expected at this stage of the project). Minor helpers (`restrictIsoUnitOfLE`, `pullbackObjUnitToUnitIso`, `pullbackSheafifyUnitEtaTriangle`) are acceptably unreferenced.

- **Proof-sketch depth**: **under-specified** on two open items:

  1. **Sq1 tail (`sheafificationCompPullback_comp_tail`)**: The blueprint says "δ-free twin of `pullbackObjUnitToUnit_comp`" but does not:
     (a) name or state the `B_{h≫f}.unit` goal form that is the isolated residual;
     (b) describe the two-layer composite-adjunction structure (B_f = (PrPbPushAdj φ'_f).comp sheafAdj_Z, similarly B_h);
     (c) separate the R0-peel (done axiom-clean in `sheaf_unit_comp_pushforward_pullbackComp_inv`) from the B-unit tail.
     A prover working from the blueprint alone must reconstruct the goal form from `pullbackObjUnitToUnit_comp` by analogy — feasible for an expert, but risks mis-targeting.

  2. **Sq4 (`pullbackValIso` composition coherence)**: The blueprint says "Sq4 becomes a short corollary once Sq1 is in hand" but gives no explicit statement for the sub-lemma. Since this must be built as a standalone declaration, the blueprint should state its goal: the composition coherence of `pullbackValIso (h ≫ f) M` in terms of `(pullback h).map (pullbackValIso f M)`, `pullbackValIso h (f^*M)`, and `(pullbackComp h f).app M`.

- **Hint precision**: precise. All `\lean{...}` hints match the correct declaration names and their signatures.

- **Generality**: matches need.

- **Recommended chapter-side actions** (for blueprint-writer agent):

  1. **(must-fix — Sq1 tail)** Add a named remark or sub-proof step in the Sq1 paragraph naming `sheafificationCompPullback_comp_tail` as the extracted residual, giving its explicit goal form (`B_{h≫f}.unit.app P` vs the RHS merged argument), and noting the two-layer composite-adjunction structure (B_f/B_h each = (PrPbPushAdj φ').comp sheafAdj). Cite the `hinner`/`hcomp'` chain as the analog.

  2. **(must-fix — Sq4)** State the Sq4 `pullbackValIso` composition coherence explicitly as a named sub-lemma goal:
     `(pullbackValIso (h ≫ f) M).hom = (pullbackComp h f).inv.app (sheafAdj.obj M.val) ≫ (pullback h).map (pullbackValIso f M).hom ≫ (pullbackValIso h ((pullback f).obj M)).hom ≫ (pullback h).map ((asIso counit).app M) ...`
     (exact form to be verified by the prover against the Lean type). Mark it as "a short corollary of Sq1 via the `pullbackValIso` factorisation `sheafCompPb.symm ≪≫ pullback.mapIso counit`".

  3. **(minor)** Add `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIsoOfLocallyTrivial}` to D4′ only after the declaration exists. The current pin without a declaration is consistent (no `\leanok`) but the plan agent should be aware.

---

## Severity summary

- **major**: Blueprint under-specified on `sheafificationCompPullback_comp_tail` (no explicit goal form for `B_{h≫f}.unit`) and on Sq4 (no explicit `pullbackValIso` coherence statement). These gaps will require the prover to guess the goal form, increasing the risk of repeated wrong targets.
- **major**: `pullbackTensorIsoOfLocallyTrivial` is blueprint-pinned but not yet declared in the Lean file. Known expected state; blocks D4' until D3' closes.
- **minor**: R0-peel decomposition (`sheaf_unit_comp_pushforward_pullbackComp_inv`) is not named or described in the blueprint; it is a non-obvious engineering step that helped the iter-263 prover make progress on Sq1.
- No must-fix-this-iter findings on existing Lean declarations — all three `sorry`s are deliberately earmarked open obligations with correct `\leanok` markers (or absent `\leanok` for D4').

**Overall verdict**: The Lean file faithfully follows the blueprint for all closed declarations; the three open `sorry`s are correctly earmarked; the chapter is adequate for the 4-square structure but must-fix under-specified for the Sq1 tail goal form and the Sq4 sub-lemma statement — 38 declarations checked, 3 sorries, 0 mis-signed declarations, 0 excuse-comments.

# Lean ↔ Blueprint Check Report

## Slug
grquot-iter053

## Iteration
053

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackComp}` (def:modules_pullbackComp)
- **Lean target exists**: N/A — `\mathlibok`, no project obligation.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correctly deferred to Mathlib; no check needed.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackBaseChangeTransport}` (lem:modules_pullback_basechange_transport)
- **Lean target exists**: yes (line 196, `noncomputable def`)
- **Signature matches**: yes — takes `p : W ⟶ V`, `a : V ⟶ Yi`, `b : V ⟶ Yj`, `g : pullback a Mi ≅ pullback b Mj`, returns `pullback (p ≫ a) Mi ≅ pullback (p ≫ b) Mj`. Blueprint describes exactly this transport: pull `g` back along `p`, reassociate via `pullbackComp`.
- **Proof follows sketch**: yes — implements the pseudofunctorial reassociation `(pullbackComp p a).symm ≪≫ (pullback p).mapIso g ≪≫ (pullbackComp p b)` which is the exact construction the blueprint describes.
- **notes**: Statement block has `\leanok` (line 76 of tex). Proof block (lines 122–149 of tex) missing `\leanok` even though the Lean def is complete — `sync_leanok` should add it.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glueData_bridge_src, glueData_bridge_mid, glueData_bridge_tgt}` (lem:gr_glueData_bridges)
- **Lean target exists**: yes — all three theorems at lines 209, 218, 230.
- **Signature matches**: yes — `bridge_src` is literally `pullback.condition`; `bridge_mid` and `bridge_tgt` match the blueprint's morphism equalities (src/mid/tgt labeling matches the tex).
- **Proof follows sketch**: yes — each rewrites with the glue datum axioms (`t_fac`, `pullback.condition`, `t_inv`, `cocycle`) as the blueprint prescribes. No sheaf data, pure bookkeeping of scheme morphisms.
- **notes**: The statement block for `lem:gr_glueData_bridges` (line 151 of tex) is **missing `\leanok`** even though all three proofs are complete. The proof block (lines 177–188) is also missing `\leanok`. These should be added by `sync_leanok`. Possible issue: `sync_leanok` may not handle a single `\begin{lemma}` block with three comma-separated `\lean{...}` names correctly — worth investigating if the markers aren't added automatically.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.glue}` (def:scheme_modules_glue)
- **Lean target exists**: yes (line 245, `noncomputable def`)
- **Signature matches**: partial — the signature is faithful: takes `D : GlueData`, `M : ∀ i, (D.U i).Modules`, transition isos `g`, conditions `_hC1` and `_hC2`, returns `D.glued.Modules`. The C1 and C2 hypotheses are encoded exactly as the blueprint describes. However, the return type only provides the glued sheaf `D.glued.Modules` — the blueprint also promises "for each i a restriction isomorphism ρ_i" as output; those restriction isomorphisms are absent from the Lean signature.
- **Proof follows sketch**: N/A — body is `:= sorry` (line 271). The blueprint's construction sketch (effective Zariski descent) is not yet formalized.
- **notes**: Statement block has `\leanok` (line 192 of tex) which is correct per blueprint semantics (declaration exists with sorry). Proof block has no `\leanok` (correct). The scaffold comments (lines 169–173 in the Lean docstring) honestly document this as blocked on the Zariski descent construction — not an excuse-comment in the deceptive sense, but honest progress tracking. The missing restriction isomorphisms in the return type may be intentional (they can be derived post-hoc) but the blueprint explicitly lists them as part of the output; this is a partial signature mismatch.

---

### `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` (def:gr_globalUnitSection)
- **Lean target exists**: yes (line 37)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) → (SheafOfModules.unit X.ringCatSheaf).sections`, matching "section of the unit sheaf attached to a global function."
- **Proof follows sketch**: yes — restriction on each open via `X.ringCatSheaf.obj.map`, compatible with restriction maps, exactly as described.
- **notes**: Statement block has `\leanok`. Clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` (def:gr_scalarEnd)
- **Lean target exists**: yes (line 50)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) → (unit X.ringCatSheaf ⟶ unit X.ringCatSheaf)`, realised via `unitHomEquiv.symm (globalUnitSection a)`.
- **Proof follows sketch**: yes — uses the `End(1) ≅ Γ(X, 1)` identification as described.
- **notes**: Clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_one}` (lem:gr_scalarEnd_one)
- **Lean target exists**: yes (line 56)
- **Signature matches**: yes — `scalarEnd (1 : Γ(X, ⊤)) = 𝟙 (unit X.ringCatSheaf)`.
- **Proof follows sketch**: yes — uses `map_one` pointwise, exactly the blueprint's argument.
- **notes**: Clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_zero}` (lem:gr_scalarEnd_zero)
- **Lean target exists**: yes (line 67)
- **Signature matches**: yes — `scalarEnd (0 : Γ(X, ⊤)) = 0`.
- **Proof follows sketch**: yes — uses `map_zero`.
- **notes**: Clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` (def:gr_chart_quotient)
- **Lean target exists**: yes (line 87)
- **Signature matches**: yes — `free (Fin r) ⟶ free (Fin d)` on `(affineChart d r I).ringCatSheaf`. The biproduct-matrix assembly via `scalarEnd` of `universalMatrix` entries is exactly the blueprint's "entry-by-entry assembly via finite biproduct."
- **Proof follows sketch**: yes (it's a definition; the body follows the blueprint's construction path).
- **notes**: Statement block has `\leanok` (line 384). Clean.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (lem:gr_chartQuotientMap_iFree)
- **Lean target exists**: yes — BUT declared as **`private lemma`** at line 103.
- **Signature matches**: yes — the mathematical content (column I of u^I = identity) matches blueprint.
- **Proof follows sketch**: yes — biproduct projection, `universalMatrix_submatrix_self`, and `scalarEnd_one`/`scalarEnd_zero` case split, exactly as the blueprint describes.
- **notes**: **CRITICAL DISCREPANCY**: The Lean declaration is `private`. In Lean 4, `private` mangles the global name; the declared name `AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree` does not exist as a public declaration. The blueprint's `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` hint is therefore broken for `sync_leanok` (which looks up the declaration by qualified name). This is a **major** issue. Fix: either remove `private`, or remove the `\lean{}` hint from the blueprint (since it's an internal helper used only within the file).

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_epi}` (lem:gr_chartQuotientMap_epi)
- **Lean target exists**: yes (line 145)
- **Signature matches**: yes — `Epi (chartQuotientMap d r I hI)`.
- **Proof follows sketch**: yes — exhibits the splitting section `freeMap (I.orderIsoOfFin hI j)`, uses `IsSplitEpi.mk'`, matches blueprint's "exhibit a section" argument.
- **notes**: Clean. Statement block has `\leanok`; proof block (lines 475–499 of tex) also has `\leanok`.

---

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (def:gr_universal_quotient_sheaf)
- **Lean target exists**: yes (line 346)
- **Signature matches**: yes — `(scheme d r).Modules`, i.e. a sheaf of modules on Gr(d,r).
- **Proof follows sketch**: N/A — body is `:= sorry` (line 347). Blocked on `glue`.
- **notes**: Statement `\leanok` is correct (sorry present). The scaffold comment ("rides on `Scheme.Modules.glue`; body to be filled once `glue` lands") is an honest progress note.

---

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (def:tautological_quotient)
- **Lean target exists**: yes (line 354)
- **Signature matches**: yes — `free (Fin r) ⟶ universalQuotient d r`.
- **Proof follows sketch**: N/A — body is `:= sorry` (line 356). Blocked on `glue`.
- **notes**: Statement `\leanok` correct. Same scaffold pattern.

---

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (def:grassmannian_functor)
- **Lean target exists**: yes (line 457)
- **Signature matches**: partial — Lean has `Scheme.{0}ᵒᵖ ⥤ Type 1`. Blueprint describes "contravariant functor from schemes to sets" but does **not** specify the universe: `Type 1` vs `Type 0` vs `Type u`. The directive explicitly calls out that the scaffold incorrectly said `Type` and it was corrected to `Type 1`. The blueprint is silent on this universe constraint. This is a precision gap in the blueprint (see adequacy section).
- **Proof follows sketch**: partial — the `obj` and `map` assignments are complete and faithful to the blueprint's description (quotient of `RankQuotient`, pullback action). The two law-proofs (`map_id`, `map_comp`) are `:= sorry` at lines 473 and 485, with detailed inline comments explaining the open obstacle (coherence of `pullbackFreeIso` with `pullbackId`/`pullbackComp`). The blueprint provides no sketch for these law proofs.
- **notes**: Statement `\leanok` is correct (declaration exists). The blueprint's `def:grassmannian_functor` block mentions the pullback action but is silent on the functor law verification. The two sorry-bearing law proofs are not flagged as open in the blueprint.

---

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (thm:grassmannian_universal_property)
- **Lean target exists**: yes (line 493)
- **Signature matches**: yes — `(functor d r).RepresentableBy (scheme d r)` with hypotheses `hd : 1 ≤ d` and `hdr : d ≤ r`, matching the blueprint's "natural bijection Hom(T, Gr(d,r)) ≅ Grass(r,d)(T)."
- **Proof follows sketch**: N/A — body is `:= sorry` (line 495). The blueprint has an extensive proof sketch (from-quotient-to-morphism, gluing, uniqueness), but the Lean proof is not yet formalized.
- **notes**: Statement `\leanok` correct. Proof block in the blueprint has no `\leanok` (correct). The extensive blueprint proof sketch (the Zariski-local construction of the inverse morphism) is adequate for future formalization.

---

## Red flags

### Placeholder / suspect bodies

- `glue` at line 271: `:= sorry`. Blueprint marks statement `\leanok` (correct — declaration exists). Proof block has no `\leanok`. The sorry is load-bearing (blocked on Zariski descent construction); honest scaffold comment at line 169–173.
- `universalQuotient` at line 347: `:= sorry`. Statement `\leanok` correct. Blocked on `glue`. Honest scaffold comment at lines 345–346.
- `tautologicalQuotient` at line 356: `:= sorry`. Statement `\leanok` correct. Blocked on `glue`. Honest scaffold comment at lines 352–353.
- `functor.map_id` at line 473: `sorry`. Statement `\leanok` (definition-level) correct. Open obstacle described in inline Lean comment (lines 469–471). Blueprint has no corresponding open-obstacle note.
- `functor.map_comp` at line 485: `sorry`. Same as above (lines 481–484 comment). Blueprint silent.
- `represents` at line 495: `:= sorry`. Statement `\leanok` correct. Proof sketch exists in blueprint; proof not yet formalized.

### Private declaration vs. public `\lean{}` reference

- `GrassmannianQuot.lean:103`: `chartQuotientMap_ιFree` is declared `private`. The blueprint's `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (tex line 434) references the unmangled public name, which does not exist as a reachable qualified declaration in Lean 4. `sync_leanok` will fail to resolve this name and will not correctly manage the `\leanok` marker for this block. **Major issue.** Fix options: (a) remove `private`, or (b) drop the `\lean{}` hint from the blueprint block and treat the lemma as a pure internal helper.

### Excuse-comments
None found that are deceptive. The scaffold comments on `universalQuotient`, `tautologicalQuotient`, and `glue` are honest progress notes ("body to be filled once X lands"), not excuses for wrong code. The inline Lean comments on `functor`'s law sorries accurately describe the open obstacle.

### Missing `\leanok` markers (sync_leanok task, not red flags per se)
- `lem:gr_glueData_bridges` statement block (tex line 151): no `\leanok` despite all three bridge theorems being axiom-clean. Likely a `sync_leanok` gap; may also be a corner case where the phase doesn't handle one `\begin{lemma}` with three comma-separated `\lean{}` names.
- Proof blocks for `pullbackBaseChangeTransport` (tex lines 122–149) and the bridge lemmas (tex lines 177–188): both are sorry-free but missing proof-block `\leanok`.

---

## Unreferenced declarations (informational)

The following 11 declarations in the Lean file have no `\lean{...}` reference in the blueprint chapter. Eight of these are substantive (not pure technical helpers):

| Declaration | Line | Status | Blueprint coverage |
|-------------|------|--------|--------------------|
| `opensMap_final` | 290 | **complete** | none |
| `pullbackFreeIso` | 309 | **complete** | none |
| `pullback_isLocallyFreeOfRank` | 322 | **complete** | none |
| `RankQuotient` (structure) | 376 | **complete** | none |
| `RankQuotient.Rel` | 389 | **complete** | none |
| `rqSetoid` (instance) | 410 | **complete** | none |
| `rqPullback` | 418 | **complete** | none |
| `rqPullback_rel` | 433 | **complete** | none |
| `RankQuotient.rel_refl` | 392 | complete (helper) | none |
| `RankQuotient.rel_symm` | 395 | complete (helper) | none |
| `RankQuotient.rel_trans` | 400 | complete (helper) | none |

`RankQuotient.rel_refl/symm/trans` are pure setoid helpers and can remain unlisted. The other eight are substantive: they encode the Lean realisation of the Grassmannian functor's object-value (`RankQuotient`, `Rel`, `rqSetoid`) and its morphism-value (`rqPullback`, `rqPullback_rel`), plus the three prerequisites needed for `rqPullback` to typecheck (`opensMap_final`, `pullbackFreeIso`, `pullback_isLocallyFreeOfRank`). A prover working purely from the blueprint could not derive the precise Lean structure names or the `opensMap_final` / `Final` argument without these blueprint blocks.

---

## Blueprint adequacy for this file

- **Coverage**: 14/25 Lean declarations have a `\lean{...}` blueprint block (counting the three bridge theorems as one block). 11 declarations are unreferenced: 3 pure helpers (acceptable), 8 substantive (see above — the entire functor-of-points encoding is undocumented).

- **Proof-sketch depth**: **under-specified** for two areas:
  1. *Functor laws*: `map_id` and `map_comp` have `sorry`-bodies open on a coherence between `pullbackFreeIso` and Mathlib's `pullbackId`/`pullbackComp`. The blueprint contains no mention of this obstacle or what it reduces to. A prover who has closed `rqPullback` and wants to close the laws has no blueprint guidance.
  2. *Glue body*: The blueprint's `def:scheme_modules_glue` construction sketch (Zariski descent / effective descent for the cover) is correct conceptually but gives no pointer to which Mathlib API to invoke (`existsUnique_gluing'`, `eq_of_locally_eq'`, etc.). The prover had to discover the path independently.

- **Hint precision**: **loose** in one case:
  - `def:grassmannian_functor` / `\lean{AlgebraicGeometry.Grassmannian.functor}`: The blueprint says "contravariant functor from schemes to sets" but does not name the universe. The Lean type is `Scheme.{0}ᵒᵖ ⥤ Type 1`. Since `T.Modules` is a large object, `Type 1` is forced — the blueprint should note this to prevent a prover from naively trying `Type 0`.

- **Generality**: **matches need** for the covered declarations. The unlisted helpers (`opensMap_final`, `pullbackFreeIso`, `pullback_isLocallyFreeOfRank`) are more general than strictly needed (they work for arbitrary morphisms, not just open immersions) — this is appropriate given the functor-of-points requires pullback along arbitrary scheme morphisms.

- **Recommended chapter-side actions** (for the blueprint-writing subagent):
  1. **Add `\lean{}` blocks for the eight substantive unlisted declarations**: `opensMap_final`, `pullbackFreeIso`, `pullback_isLocallyFreeOfRank`, `RankQuotient`, `RankQuotient.Rel`, `rqSetoid`, `rqPullback`, `rqPullback_rel`. These are the core building blocks of the functor's Lean encoding and should each have a brief definition block explaining the mathematical object they represent.
  2. **Document the `Type 1` universe** in `def:grassmannian_functor`: add a sentence noting that `T.Modules` is a large type so `Grass(r,d)(T)` lives in `Type 1`, not `Type 0`.
  3. **Add an "open obstacle" note** to the `def:grassmannian_functor` block (or in a proof block for `map_id`/`map_comp`): the two functor law sorries reduce to a coherence between `SheafOfModules.pullbackObjFreeIso` and Mathlib's `pullbackId`/`pullbackComp` at the unit-module level. Naming this crux gives the next prover a target.
  4. **Fix the `chartQuotientMap_ιFree` issue**: decide whether to keep the lemma private (drop the `\lean{}` hint) or make it non-private (keep the hint). The `\lean{}` hint on a `private` declaration is currently broken for `sync_leanok`.
  5. **Investigate multi-name `\lean{}` block handling**: the single `\begin{lemma}` for `lem:gr_glueData_bridges` with three comma-separated names has no `\leanok` despite all three proofs being sorry-free. Verify that `sync_leanok` correctly handles such blocks; if not, split into three separate lemma blocks or fix the phase.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `chartQuotientMap_ιFree` is `private` but has public `\lean{}` reference — breaks `sync_leanok` | **major** |
| `glue` return type omits the restriction isomorphisms `ρ_i` promised by blueprint | **major** |
| 8 substantive declarations (functor-of-points encoding) have no `\lean{}` blueprint blocks | **major** |
| `functor` law sorries (`map_id`/`map_comp`) not flagged as open in the blueprint | **major** |
| Blueprint omits `Type 1` universe for `functor` return type | **minor** |
| `lem:gr_glueData_bridges` statement and proof blocks missing `\leanok` (sync_leanok gap) | **minor** |
| `pullbackBaseChangeTransport` proof block missing `\leanok` (sync_leanok gap) | **minor** |

**Overall verdict**: The declarations that are complete are well-matched to their blueprint blocks; the four major issues are a broken `private`/`\lean{}` pairing, a partial signature mismatch on `glue` (missing restriction isos), missing blueprint coverage for the entire functor-of-points machinery (11 unblueprinted declarations, 8 substantive), and undocumented open functor-law sorries — none rises to must-fix-this-iter because no proof block `\leanok` is incorrectly applied to a sorry-bearing proof, but the blueprint chapter needs significant augmentation before the functor section is adequately specified.

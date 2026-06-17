# Lean ↔ Blueprint Check Report

## Slug
grquot-iter052

## Iteration
052

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackComp}` (def:modules_pullbackComp)
- **Lean target exists**: N/A — marked `\mathlibok`; provided by Mathlib
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Correct; no Archon obligation.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackBaseChangeTransport}` (lem:modules_pullback_basechange_transport)
- **Lean target exists**: yes (line 196, `noncomputable def`)
- **Signature matches**: yes — `(p : W ⟶ V) (a : V ⟶ Yi) (b : V ⟶ Yj) (g : a^* Mi ≅ b^* Mj) : (p ≫ a)^* Mi ≅ (p ≫ b)^* Mj`; Lean is more general than the blueprint (which describes only the glue-datum case), which is acceptable generalization
- **Proof follows sketch**: yes — body is `(pullbackComp p a).symm.app Mi ≪≫ (pullback p).mapIso g ≪≫ (pullbackComp p b).app Mj`, exactly the three-step reassociation the prose describes (left `pullbackComp` inv, functorial pullback, right `pullbackComp`)
- **notes**: Proof is complete (no sorry). Blueprint statement block has `\leanok`; proof block does NOT have `\leanok` yet. `sync_leanok` should add it next run — minor state lag.

### `\lean{AlgebraicGeometry.Scheme.Modules.glue}` (def:scheme_modules_glue)
- **Lean target exists**: yes (line 245)
- **Signature matches**: yes — takes `(D : Scheme.GlueData)`, per-chart modules `M`, transition isos `g`, with `_hC1` (self-identity) and `_hC2` (triple-overlap multiplicativity) hypotheses; returns `D.glued.Modules`
- **Proof follows sketch**: N/A (body is `sorry`; planner-deferred scaffold)
- **notes**: C2 hypothesis is the key new addition this iter. See dedicated C2 check below. Scaffold sorry is honestly documented: `NOTE (scaffold): the body and the module-cocycle hypotheses on g are still to be filled`. Blueprint `\leanok` is on the statement block only — consistent with a sorry-bodied def.

#### C2 hypothesis detailed check (directive item)

Blueprint C2 (informal): `ĝ^k_jk ∘ ĝ^k_ij = ĝ^j_ik` over `V_ijk`, with the three `glueData_bridge_*` identities + `pullbackCongr` making the equation well-typed (blueprint prose: "The three `glueData_bridge_*` identities, applied through `pullbackCongr`, line up the endpoints so the equation is well typed").

Lean C2 (`_hC2`, lines 260–269):
```
∀ i j k,
    pullbackBaseChangeTransport (pullback.fst (D.f i j) (D.f i k))
        (D.f i j) (D.t i j ≫ D.f j i) (g i j) ≪≫
      (Scheme.Modules.pullbackCongr (glueData_bridge_mid D i j k)).app (M j) ≪≫
      pullbackBaseChangeTransport (D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i))
        (D.f j k) (D.t j k ≫ D.f k j) (g j k) ≪≫
      (Scheme.Modules.pullbackCongr (glueData_bridge_tgt D i j k)).app (M k)
    = (Scheme.Modules.pullbackCongr (glueData_bridge_src D i j k)).app (M i) ≪≫
      pullbackBaseChangeTransport (pullback.snd (D.f i j) (D.f i k))
        (D.f i k) (D.t i k ≫ D.f k i) (g i k)
```

**Assessment: faithful translation.** The informal `ĝ_jk ∘ ĝ_ij = ĝ_ik` is encoded with the three `pullbackCongr (glueData_bridge_*)` iso-insertions as explicit type-alignment operators, exactly as the blueprint prose describes. The LHS transports `g i j` along `pullback.fst` (= `p^{ij}_{ijk}`), then conjugates by `glueData_bridge_mid` to land the target on the same sheaf as the source of the `g j k` transport, which is taken along `D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i)`; the RHS transports `g i k` along `pullback.snd` after conjugating the source by `glueData_bridge_src`. This matches the blueprint's description of the three-leg transport schema. No discrepancy.

### `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` (def:gr_globalUnitSection)
- **Lean target exists**: yes (line 37)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) : (SheafOfModules.unit X.ringCatSheaf).sections`, matching the blueprint's "section of the unit sheaf attached to a global function"
- **Proof follows sketch**: yes — body constructs the compatible family by restriction, consistent with the prose
- **notes**: Complete, no sorry.

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` (def:gr_scalarEnd)
- **Lean target exists**: yes (line 50)
- **Signature matches**: yes — `(a : Γ(X, ⊤)) : SheafOfModules.unit X.ringCatSheaf ⟶ SheafOfModules.unit X.ringCatSheaf`; blueprint says "O_X-linear endomorphism given by multiplication by a"
- **Proof follows sketch**: yes — uses `unitHomEquiv.symm` exactly as the blueprint's "under the canonical identification End(1) ≅ Γ(X,1)"
- **notes**: Complete, no sorry.

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_one}` (lem:gr_scalarEnd_one)
- **Lean target exists**: yes (line 56)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Complete, no sorry.

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_zero}` (lem:gr_scalarEnd_zero)
- **Lean target exists**: yes (line 67)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Complete, no sorry.

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` (def:gr_chart_quotient)
- **Lean target exists**: yes (line 87)
- **Signature matches**: yes — free sheaf `(Fin r)` → free sheaf `(Fin d)` on `affineChart d r I`; realizes the universal matrix as a biproduct morphism via `scalarEnd`
- **Proof follows sketch**: yes — entry-by-entry biproduct assembly via `biproduct.matrix`, matching the blueprint's "no off-the-shelf primitive" note
- **notes**: Complete, no sorry.

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (lem:gr_chartQuotientMap_iFree)
- **Lean target exists**: yes (line 103), BUT declared `private`
- **Signature matches**: yes — `SheafOfModules.ιFree (I.orderIsoOfFin hI k) ≫ chartQuotientMap d r I hI = SheafOfModules.ιFree k`; matches blueprint's "I-indexed columns of u^I form the identity"
- **Proof follows sketch**: yes — biproduct row extraction + `universalMatrix_submatrix_self` + `scalarEnd_one/zero`, exactly the blueprint's argument
- **notes**: **MAJOR ISSUE — see Red Flags.** The declaration is `private` but the blueprint references it by its unmangled public name. `sync_leanok` will fail to find it, potentially removing the `\leanok` marker.

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_epi}` (lem:gr_chartQuotientMap_epi)
- **Lean target exists**: yes (line 145)
- **Signature matches**: yes — `Epi (chartQuotientMap d r I hI)`
- **Proof follows sketch**: yes — split via `IsSplitEpi.mk'` from the right-section `freeMap ≫ chartQuotientMap = 𝟙`; matches blueprint's split-epi argument
- **notes**: Complete, no sorry.

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (def:gr_universal_quotient_sheaf)
- **Lean target exists**: yes (line 284), body is `sorry`
- **Signature matches**: yes — `(scheme d r).Modules`
- **Proof follows sketch**: N/A (scaffold sorry)
- **notes**: Honestly documented: "NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands." Blueprint `\leanok` on statement block only. Consistent.

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (def:tautological_quotient)
- **Lean target exists**: yes (line 292), body is `sorry`
- **Signature matches**: yes — `SheafOfModules.free (Fin r) ⟶ universalQuotient d r`, i.e. `O^r → U`
- **Proof follows sketch**: N/A (scaffold sorry)
- **notes**: Honestly documented. Blueprint `\leanok` on statement block only. Consistent.

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (def:grassmannian_functor)
- **Lean target exists**: yes (line 304), body is `sorry`
- **Signature matches**: yes — `Scheme.{0}ᵒᵖ ⥤ Type`; contravariant functor schemes → sets
- **Proof follows sketch**: N/A (scaffold sorry)
- **notes**: Honestly documented. Blueprint `\leanok` on statement block only. Consistent.

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (thm:grassmannian_universal_property)
- **Lean target exists**: yes (line 313), body is `sorry`
- **Signature matches**: yes — `(functor d r).RepresentableBy (scheme d r)` given `1 ≤ d` and `d ≤ r`
- **Proof follows sketch**: N/A (scaffold sorry)
- **notes**: Honestly documented: "NOTE (scaffold): body (the local-to-global inverse construction of Nitsure §1) to be filled once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land." Blueprint has `\leanok` on statement block only, and a complete proof sketch in the `\begin{proof}` block (no `\leanok` there). Consistent.

---

## Red Flags

### Placeholder / suspect bodies
All five scaffold sorries (`glue`, `universalQuotient`, `tautologicalQuotient`, `functor`, `represents`) are `:= sorry` with explicit NOTE comments stating the dependency chain. The blueprint's `\leanok` markers cover statement blocks only; none has a proof-block `\leanok`. This is **honest** scaffold state — not a red flag per se — but the sorries are noted for completeness:
- `Scheme.Modules.glue` line 271: `:= sorry`, documented scaffold
- `universalQuotient` line 285: `:= sorry`, documented scaffold
- `tautologicalQuotient` line 294: `:= sorry`, documented scaffold
- `functor` line 305: `:= sorry`, documented scaffold
- `represents` line 315: `:= sorry`, documented scaffold

These are planner-deferred; the directive confirms "Body still sorry (planner-deferred) — is that honest?" — **yes, all five are honestly documented**.

### Wrong accessibility on a blueprinted declaration
- **`chartQuotientMap_ιFree` at line 103**: declared `private lemma`. In Lean 4, `private` declarations receive a mangled internal name (e.g., `_private.AlgebraicJacobian.Picard.GrassmannianQuot.AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree`). The blueprint references `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}`, which is the *unmangled* public name. The `sync_leanok` tool and any external name-lookup tool will fail to resolve this name, causing the `\leanok` marker on `lem:gr_chartQuotientMap_iFree` to be removed by the next `sync_leanok` run. **Severity: major.**

---

## Unreferenced declarations (informational)

The following Lean declarations have **no `\lean{...}` blueprint block**:

| Declaration | Lines | Notes |
|---|---|---|
| `glueData_bridge_src` | 209–211 | Proved (`pullback.condition`); mentioned in blueprint prose as one of "the three `glueData_bridge_*` identities" but no `\lean{}` block. **Coverage debt.** |
| `glueData_bridge_mid` | 218–222 | Proved (algebra from `t_fac` + `pullback.condition`); same as above. **Coverage debt.** |
| `glueData_bridge_tgt` | 230–238 | Proved (algebra from `t_fac`, `pullback.condition`, `t_inv`, `cocycle`); same as above. **Coverage debt.** |

All three are acknowledged in the blueprint prose:
> "The three scheme-level `glueData_bridge_*` identities below (consequences of `t_fac`, `pullback.condition` and `cocycle`) line up the endpoints of the three transports so that the cocycle equation is well typed."

The prose is in the module-doc comment of the Lean file (not in the blueprint chapter). The blueprint chapter does NOT have this explanation or the `\lean{}` references. They are load-bearing typed helpers for the C2 hypothesis — their proofs are complete — but they are invisible to blueprint tooling.

---

## Blueprint adequacy for this file

- **Coverage**: 11/14 Lean declarations have a corresponding `\lean{...}` block in the chapter. The 3 unreferenced declarations (`glueData_bridge_src/mid/tgt`) are substantive proved theorems the blueprint acknowledges in prose but does not formally blueprint.
- **Proof-sketch depth**: **adequate** for the declarations with complete proofs (`globalUnitSection`, `scalarEnd`, `scalarEnd_one/zero`, `chartQuotientMap`, `chartQuotientMap_ιFree`, `chartQuotientMap_epi`, `pullbackBaseChangeTransport`). For the scaffold sorries, the blueprint has detailed construction sketches (especially `def:scheme_modules_glue` and `thm:grassmannian_universal_property`) that are rich enough to guide future formalization.
- **Hint precision**: **precise** — all `\lean{...}` hints name the correct Lean declarations, except for `chartQuotientMap_ιFree` which is `private` (see Red Flags).
- **Generality**: **matches need** — the Lean `pullbackBaseChangeTransport` is more general than what the blueprint describes (it works for any pair of morphisms `a, b : V ⟶ Y_i/Y_j`, not just glue-datum legs), which is an appropriate generalization.
- **Recommended chapter-side actions**:
  1. Add `\lean{AlgebraicGeometry.Scheme.Modules.glueData_bridge_src}`, `\lean{...glueData_bridge_mid}`, `\lean{...glueData_bridge_tgt}` blocks (as short helper lemmas) to cover the three bridge theorems. These are proved this iter; coverage debt should be resolved.
  2. Once `chartQuotientMap_ιFree` is made non-private, verify that `sync_leanok` recovers the `\leanok` for `lem:gr_chartQuotientMap_iFree`.
  3. Add `\leanok` to the proof block of `lem:modules_pullback_basechange_transport` (proof is complete; `sync_leanok` should handle this automatically next run).

---

## Severity summary

| Finding | Severity |
|---|---|
| `chartQuotientMap_ιFree` declared `private` but blueprinted under its public name — `sync_leanok` will fail to resolve it | **major** |
| `glueData_bridge_src/mid/tgt` — three proved theorems with no `\lean{...}` blueprint blocks (coverage debt, flagged by directive) | minor |
| Proof-block `\leanok` missing for `pullbackBaseChangeTransport` (proof complete; `sync_leanok` state lag) | minor |
| Five scaffold sorries (`glue`, `universalQuotient`, `tautologicalQuotient`, `functor`, `represents`) — honest, planner-deferred, consistent with blueprint markers | informational |
| C2 hypothesis (`_hC2`) faithfully encodes blueprint's `ĝ_jk ∘ ĝ_ij = ĝ_ik` with explicit type-alignment operators | ✅ no issue |
| `pullbackBaseChangeTransport` signature matches blueprint | ✅ no issue |

**Overall verdict**: File is in an honest scaffold state with one major tooling issue (`chartQuotientMap_ιFree` being `private` while blueprinted), three minor coverage gaps for the new bridge helpers, and five legitimately deferred scaffold sorries; no signature mismatches or misleading proofs. — 14 declarations checked (11 blueprinted, 3 unreferenced), 1 major + 3 minor findings.

# Lean ↔ Blueprint Check Report

## Slug
leg

## Iteration
075

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushPull_interLegHom_sections}` (chapter: `lem:pushPull_interLegHom_sections`, bp line ~8847)

- **Lean target exists**: yes (line 1416, public `lemma`)
- **Signature matches**: yes
  - Blueprint: `G_V(Ψ(interLegHom 𝒰 σ' k)) ∘ pls(σ').hom = pls(σ'∘d_k).hom ∘ F(homOfLE(U_{σ'} ∩ V ⊆ U_{σ'∘d_k} ∩ V))`
  - Lean:
    ```
    (sectionFunctorV V).map (pushPullMap F (interLegHom 𝒰 σ' k)) ≫
        (pushPull_leg_sections 𝒰 F σ' V).hom =
      (pushPull_leg_sections 𝒰 F (σ' ∘ (SimplexCategory.δ k).toOrderHom) V).hom ≫
        F.presheaf.map (homOfLE (inf_le_inf_right V ...)).op
    ```
  - These are definitionally the same. ✓
- **Proof follows (a)–(d) sketch**: yes, with the following realization:
  - Steps (a)+(b)+(c) are pre-packaged in the new public helper `pushPull_toRestrict_comm` (line 1277). That lemma encodes the leg-coherence factorization, the unit/pullback comparison, and the composition law in a single commutative diagram.
  - Step (d) (thin-category collapse to plain F-restriction) is handled by `thin_resid5` (private, line 1378) and `pls_eq` (private, line 1398).
  - The blueprint's step (a) invokes `pushPull_leg_coherence` by name; the Lean proof doesn't call it directly — it calls `pushPull_toRestrict_comm`, which internally uses `pushPull_leg_coherence` (via `rawPushPullMap_self_gen`) plus Steps (b)–(c). Mathematically faithful; different structuring.
- **No sorry in proof body**: confirmed — `grep sorry` found only the module docstring comment.
- **notes**: Proof is complete. All (a)–(d) steps realized. No placeholder or excuse comment in the proof itself.

---

### `\lean{AlgebraicGeometry.pushPull_leg_coherence}` (chapter: `lem:pushPull_leg_coherence`, bp line ~8808)

- **Lean target exists**: yes, but declared `private` (line 974: `private lemma pushPull_leg_coherence`)
- **Signature matches**: yes
  - Blueprint: `pushPullMap F (Over.homMk c wC) = q_*(η^c_{q^*F}) ≫ (pushPullLegIso q c pC wC F).hom`
  - Lean: `pushPullMap F (Over.homMk c wC : Over.mk pC ⟶ Over.mk q) = (pushforward q).map ((restrictAdjunction c).unit.app ((pullback q).obj F)) ≫ (pushPullLegIso q c pC wC F).hom`
  - Exact match. ✓
- **Proof follows sketch**: yes — proof uses `rawPushPullMap_self_gen`, the `hLAU` unit intertwining identity, `subst wC` (collapsing reindexing isos to identities), and `rfl` as the final step. All four described steps of the blueprint proof are realized.
- **No sorry in proof body**: confirmed.
- **⚠️ ISSUE**: The Lean declaration is `private`. The blueprint hint `\lean{AlgebraicGeometry.pushPull_leg_coherence}` names a `private` declaration. In Lean 4, `private` definitions receive a mangled name (e.g., `_private.AlgebraicGeometry.CechSectionIdentificationLeg.pushPull_leg_coherence.1`). No tool — including `sorry_analyzer` or the blueprint web framework — can resolve the stated name `AlgebraicGeometry.pushPull_leg_coherence`. The hint is technically wrong.

---

### `\lean{AlgebraicGeometry.coreIso_comm_leg}` (chapter: `lem:coreIso_comm_leg`, bp line ~9014)

- **Lean target exists**: yes (line 1544, public `lemma`)
- **Signature matches**: yes
  - Blueprint: the σ'-coordinate of `G_V(Ψ(δᵏ)) ≫ (objIso (p+1)).hom` = `sectionCechFaceRestr(σ', k)` applied to the `(σ'∘d_k)`-coordinate of `(objIso p).hom`
  - Lean: matches exactly, projecting via `Pi.π` and using `sectionCechFaceRestr`. ✓
- **Proof follows sketch**: yes — the proof:
  1. Assembles `hmid` using `backboneIncl_nerveδ`, `pushPull_interLegHom_sections`, and `coreIso_objIso_π`
  2. Uses `cechNerve_drop_δ` and `GVΨ_map_eq` to collapse the nerve coface to the push–pull map
  3. Chains through `coreIso_objIso_π` on both sides
  4. Uses `map_op_eqToHom_swap` for the thin-category reindex
  - This implements exactly the blueprint's described strategy.
- **No sorry in proof body**: confirmed.
- **⚠️ CRITICAL STALE CLAIM**: Module-level docstring at line 15 reads:
  ```
  Carries the residual sorry `coreIso_comm_leg`.
  ```
  This claim is FALSE. The proof of `coreIso_comm_leg` is complete (no `:= sorry` anywhere in the file). The sorry was apparently closed this iteration, but the file header was not updated. This is a stale statement that misrepresents the file's state.

---

### `\lean{AlgebraicGeometry.coreIso_comm_coface}` (chapter: `lem:coreIso_comm_coface`, bp line ~9063)

- **Lean target exists**: yes (line 1617, public `lemma`)
- **Signature matches**: yes ✓
- **Proof follows sketch**: yes — coordinatewise via `Pi.hom_ext` and `sectionCechProductEquiv`, using `coreIso_comm_leg` as a subroutine. Matches blueprint description exactly.
- **No sorry**: confirmed.

---

### `\lean{AlgebraicGeometry.coreIso_comm_sum}` (chapter: `lem:coreIso_comm_sum`, bp line ~9093)

- **Lean target exists**: yes (line 1652, public `lemma`)
- **Signature matches**: yes ✓
- **Proof follows sketch**: yes — elementwise via `sectionCechProductEquiv`, distributing `Functor.map_sum` and `Functor.map_zsmul`, then invoking `coreIso_comm_leg` per summand. Blueprint says exactly this.
- **No sorry**: confirmed.
- **notes**: The blueprint proof (lines 9103–9113) is adequate. The dead-end note (no `Preadditive.comp_sum` against `AddCommGrpCat`) from iter-067 mentioned in the Lean docstring is consistent with the proof having gone elementwise.

---

### `\lean{AlgebraicGeometry.coreIso_comm}` (chapter: `lem:coreIso_comm`, bp line ~9120)

- **Lean target exists**: yes (line 1790, public `lemma`)
- **Signature matches**: yes ✓
- **Proof**: short, uses `coreIso_comm_sum` — matches blueprint exactly.
- **No sorry**: confirmed.
- **Blueprint `\leanok` marker**: present at line 9118 (inside the statement block). This is consistent with the proof being complete.

---

## Red Flags

### Stale claim in module docstring

- **`CechSectionIdentificationLeg.lean`, line 15** (in the module-level `/- ... -/` docstring):
  > `Carries the residual sorry coreIso_comm_leg.`
  
  The sorry for `coreIso_comm_leg` has been closed this iteration. The proof body (lines 1544–1609) contains no `sorry`. This statement is **factually wrong** and will mislead any agent or human reading the file header.

### Blueprint `\lean{}` hint pointing to a `private` declaration

- **Blueprint line 8809**: `\lean{AlgebraicGeometry.pushPull_leg_coherence}`
- **Lean file line 974**: `private lemma pushPull_leg_coherence`
- In Lean 4, `private` declarations are not accessible by their short qualified name from outside the file. The blueprint hint cannot be resolved by automated tools (`sorry_analyzer`, the blueprint web framework, etc.) under the stated name. The tool will report "declaration not found" even though the correct-signature proof exists.

### Missing `\leanok` markers

The following blueprint blocks have complete, sorry-free Lean proofs but lack `\leanok` in their statement or proof blocks:
- `lem:pushPull_leg_coherence` (bp lines 8806–8843): no `\leanok`
- `lem:pushPull_interLegHom_sections` (bp lines 8845–8907): no `\leanok`
- `lem:coreIso_comm_leg` (bp lines 9012–9058): no `\leanok`
- `lem:coreIso_comm_coface` (bp lines 9060–9088): no `\leanok`
- `lem:coreIso_comm_sum` (bp lines 9090–9114): no `\leanok`

(`lem:coreIso_comm` at line 9116 **does** have `\leanok` at line 9118.) These are normally handled by `sync_leanok` and are not a proof error; noted here for completeness.

---

## Unreferenced declarations (informational)

The following non-private declarations appear in the Lean file but have **no** `\lean{...}` reference in the blueprint chapter:

### Substantive public helpers (coverage debt — added this iteration)
These encode the detailed content of blueprint steps (a)–(d) for `pushPull_interLegHom_sections` and needed to be invented without blueprint guidance:

| Lean declaration | Line | Description |
|---|---|---|
| `unit_pushforward_rFIP_inv` | 1007 | Step 0: restriction-unit ∘ rFIP-inverse = pullback-pushforward unit |
| `restrict_unit_comp` | 1051 | Step 1: iterated restriction units compose via `restrictFunctorComp` |
| `inner_beta_chain` | 1078 | β-chain collapse for inner adjunction units |
| `pullbackComp_rFIP_compat` | 1169 | Step 2: `pullbackComp` conjugated to restrict-world = `restrictFunctorComp` |
| `pushPull_toRestrict_comm` | 1277 | Step 3: push-pull map of open immersion, conjugated to restrict-world |

These five are the substantive new lemmas this iteration that together realize steps (a)–(d). None have a blueprint entry.

### Smaller public helpers (minor)
| Lean declaration | Line |
|---|---|
| `pushPull_sigma_iso_π_incl` | 71 |
| `over_hom_ext_mono` | 145 |
| `sectionFunctorV` (abbrev) | 876 — *this IS referenced* via `\lean{AlgebraicGeometry.sectionFunctorV}` at bp line 8977 |

(The `backbone_hom_ext`, `nerveδ_backboneProj`, `cechNerve_drop_δ`, `coreIso_objIso_π`, `interLegHom`, `interLegHom_interProj`, `backboneIncl`, etc. are all referenced in the chapter.)

---

## Blueprint adequacy for this file

- **Coverage**: 8/8 top-level public lemmas with `\lean{}` hints are present and faithfully formalized. However, 5 substantive intermediate public helper lemmas introduced this iteration have no blueprint entries. Coverage ratio for these new helpers: 0/5.

- **Proof-sketch depth**: **under-specified** for `lem:pushPull_interLegHom_sections`. The (a)–(d) sketch (bp lines 8875–8906) is correct in outline, but steps (b)–(d) each required a standalone lemma (`unit_pushforward_rFIP_inv`, `restrict_unit_comp`, `inner_beta_chain`, `pullbackComp_rFIP_compat`) that the blueprint doesn't mention. A prover working solely from the blueprint could not have known these intermediate steps were needed; they were discovered in-flight. The sketch is thin for steps (b)–(d).

- **Proof-sketch depth**: **adequate** for `lem:pushPull_leg_coherence`, `lem:coreIso_comm_leg`, `lem:coreIso_comm_coface`, `lem:coreIso_comm_sum`, and `lem:coreIso_comm`. The sketches guided the Lean proofs without requiring extra undocumented sub-steps.

- **Hint precision**: **partially wrong** for `lem:pushPull_leg_coherence`. The `\lean{AlgebraicGeometry.pushPull_leg_coherence}` hint names a `private` declaration that cannot be looked up by that name. The remaining `\lean{}` hints are correct.

- **Generality**: matches need. The general form (arbitrary `q : A → X`, not just coproduct inclusions) of `pushPull_leg_coherence` is correctly used by `pushPull_interLegHom_sections`.

- **Recommended chapter-side actions** (for the blueprint-writing subagent):
  1. Add `\lean{}` blocks and brief proof sketches for the five new intermediate helpers: `unit_pushforward_rFIP_inv`, `restrict_unit_comp`, `inner_beta_chain`, `pullbackComp_rFIP_compat`, `pushPull_toRestrict_comm`. These encode the real mathematical work of the (b)–(d) steps and are now standalone public lemmas.
  2. Fix the `\lean{}` hint for `lem:pushPull_leg_coherence`: either promote the Lean declaration from `private` to non-private so the name `AlgebraicGeometry.pushPull_leg_coherence` resolves, or update the hint to reflect the actual Lean name.
  3. Add `\leanok` to `lem:pushPull_leg_coherence`, `lem:pushPull_interLegHom_sections`, `lem:coreIso_comm_leg`, `lem:coreIso_comm_coface`, `lem:coreIso_comm_sum` (or let `sync_leanok` handle it next run).

---

## Severity summary

| Finding | Severity |
|---|---|
| Stale module docstring (line 15) claiming `coreIso_comm_leg` carries a sorry — it does not | **major** |
| `\lean{AlgebraicGeometry.pushPull_leg_coherence}` pointing to a `private` declaration — tool-unresolvable | **major** |
| 5 new substantive public helper lemmas (Steps 0–3 of `pushPull_interLegHom_sections`) with no blueprint entry | **major** (coverage debt) |
| Proof sketch for `lem:pushPull_interLegHom_sections` steps (b)–(d) too thin to have guided formalization | **major** (blueprint adequacy) |
| `pushPull_sigma_iso_π_incl`, `over_hom_ext_mono` lack blueprint entries | **minor** |
| Missing `\leanok` on 5 proved lemmas (sync_leanok will fix) | **minor** |

**Overall verdict**: All three focus lemmas (`pushPull_interLegHom_sections`, `pushPull_leg_coherence`, `coreIso_comm_leg`) are faithfully formalized with complete, sorry-free proofs matching the blueprint statements; the must-fix actions are the stale module-header claim and the private/public mismatch in the `\lean{}` hint, plus blueprint coverage debt from five new intermediate helper lemmas — 8 declarations checked, 2 red flags (stale docstring, private-name hint) and 1 coverage-debt cluster.

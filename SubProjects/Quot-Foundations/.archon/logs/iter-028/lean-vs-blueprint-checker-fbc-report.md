# Lean ↔ Blueprint Check Report

## Slug
fbc

## Iteration
028

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Directive questions (iter-028 targeted)

**Q1. Does the Lean proof structure match the chapter's Seam-A routing (through `_legs`, not inline)? Any signature mismatch with `\lean{...}`?**

YES. `base_change_mate_inner_value_eq` (line 1634) closes by `exact base_change_mate_fstar_reindex ψ φ M`, which closes by `exact base_change_mate_fstar_reindex_legs ...`. The blueprint's `lem:base_change_mate_inner_value_eq` correctly documents this as "instantiation of the leg-parametrised reindex at the projection legs." No `\lean{...}` signature mismatches were found across all ~52 referenced declarations.

**Q2. Is the chapter honest that `inner_eCancel_assemble`/`_legs` remains open, while downstream theorem bodies are closed-but-transitively-sorry-backed?**

MOSTLY YES. Every proof block with a live sorry (direct or transitive) lacks `\leanok` — the blueprint correctly withholds the marker. However, the proof sketch of `lem:base_change_mate_gstar_transpose` (step 3) cites `lem:base_change_mate_inner_value_eq` as if it is established, when the Lean code explicitly notes (line 1743) that it CANNOT be cited because it is sorry-backed — the inline reproof is needed instead. That sketch is misleading about the current proof architecture. (See Red Flags §2 below.)

**Q3. Is the chapter detailed enough to guide the diamond-robust telescoping that remains?**

PARTIAL / INADEQUATE. `lem:base_change_mate_inner_eCancel_assemble` says "apply the three one-cancellation atoms in turn." Mathematically correct, but the Lean file's sorry comments (lines 1392–1444) document that ALL tactic-rewrite routes (`rw`, `simp only`, `erw`) fail silently against the `X.Modules` `CategoryStruct.comp` instance diamond. The chapter provides no Lean-level guidance: it does not name the diamond, does not note that `simp only [Functor.map_comp]` makes no progress, does not mention that `erw [gammaMap_pushforwardComp_hom_eq_id]` times out, and does not describe the term-mode congruence surgery that remains the viable route. A prover cannot resolve the sorry from the chapter prose alone. (See Red Flags §1 below.)

---

## Per-declaration

Declarations are grouped. Only entries with a notable finding receive expanded notes; the rest are ✓ or noted inline.

### Infrastructure / helpers (all sorry-free, all stmt-`\leanok` present, proof-`\leanok` consistent)

| `\lean{...}` | Chapter block | Exists | Sig | Proof vs sketch | Notes |
|---|---|---|---|---|---|
| `AlgebraicGeometry.pushforwardBaseChangeMap` | `def:pushforward_base_change_map` | ✓ | ✓ | N/A (def) | — |
| `AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map` | `lem:modules_isIso_iff_stalkFunctor` | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis` | `lem:modules_isIso_of_app_basis` | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens` | `lem:modules_isIso_iff_affineOpens` | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop` | helper | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.gammaPushforwardIso` | `lem:gammaPushforwardIso` | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.gammaPushforwardTildeIso` | `lem:gammaPushforwardTildeIso` | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.gammaPushforwardIsoAt` | `lem:gammaPushforwardIsoAt` | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.tildeRestriction_isLocalizedModule` | helper | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars` | helper | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule` | helper | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule` | helper | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.pushforward_spec_tilde_iso` | `lem:pushforward_spec_tilde_iso` | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.pullback_fst_snd_specMap_tensor` | helper | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.gammaPushforwardNatIso` | `lem:gammaPushforwardNatIso` | ✓ | ✓ | ✓ | — |
| `AlgebraicGeometry.pullback_spec_tilde_iso` | `lem:pullback_spec_tilde_iso` | ✓ | ✓ | ✓ | — |

### Mathlib anchors (`\mathlibok`)

`pullbackSpecIso`, `TensorProduct.AlgebraTensorModule.cancelBaseChange`, `Algebra.IsPushout.cancelBaseChange`, `pullbackIsoEquivalenceOfIso`, `pullback_isEquivalence_of_iso`, `CategoryTheory.unit_conjugateEquiv`, `CategoryTheory.Adjunction.comp_unit_app`, `Scheme.Modules.conjugateEquiv_pullbackComp_inv`, `LinearMap.tensorEqLocusEquiv` — all correctly marked `\mathlibok`, no Lean obligation.

### Tilde dictionaries and regroup (sorry-free)

| `\lean{...}` | Chapter block | Notes |
|---|---|---|
| `base_change_mate_domain_read` | `lem:base_change_mate_domain_read` | ✓ |
| `base_change_mate_codomain_read` | `lem:base_change_mate_codomain_read` | ✓ |
| `base_change_mate_codomain_read_legs` | `lem:base_change_mate_codomain_read_legs` | ✓ |
| `base_change_mate_regroupEquiv` | `lem:base_change_mate_regroupEquiv` | ✓; `lem:base_change_regroup_linearEquiv` appears in `\uses` but has no `\lean{...}` and no Lean decl in this file — see Unreferenced §. |
| `pullbackPushforward_unit_comp` | `lem:pullbackPushforward_unit_comp` | ✓ |
| `base_change_mate_unit_value` | `lem:base_change_mate_unit_value` | ✓ |
| `base_change_mate_inner_value` | `def:base_change_mate_inner_value` | ✓ (def) |

### Private-visibility helpers referenced by `\lean{...}`

**MINOR issue for all three below** — the declarations carry `private lemma` in Lean 4, meaning their actual exported names are mangled (`_private.<hash>.name`). The blueprint uses the bare public-form names. `leandag` graph edges to these three nodes may resolve to `null`.

| `\lean{...}` | Chapter block | Exists (as private) | Sig | Notes |
|---|---|---|---|---|
| `AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id` | internal atom | ✓ private | ✓ | **MINOR**: `private` but `\lean{...}` uses public name |
| `AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id` | internal atom | ✓ private | ✓ | **MINOR**: same |
| `AlgebraicGeometry.gammaMap_pushforwardCongr_hom` | internal atom | ✓ private | ✓ | **MINOR**: same |

### eCancel atoms and unitExpand (sorry-free helpers)

| `\lean{...}` | Chapter block | Notes |
|---|---|---|
| `base_change_mate_fstar_reindex_legs_unitExpand` | `lem:base_change_mate_fstar_reindex_legs_unitExpand` | ✓ |
| `base_change_mate_fstar_reindex_legs_gammaDistribute` | `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` | ✓ |
| `base_change_mate_inner_eCancel_eUnit` | `lem:base_change_mate_inner_eCancel_eUnit` | ✓ |
| `base_change_mate_inner_eCancel_pushforwardComp` | `lem:base_change_mate_inner_eCancel_pushforwardComp` | ✓ |
| `base_change_mate_inner_eCancel_pullbackComp` | `lem:base_change_mate_inner_eCancel_pullbackComp` | ✓ |

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` — `lem:base_change_mate_fstar_reindex_legs`

- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: **partial** — steps (i) unitExpand and (ii) gammaDistribute are closed; step (iii) eCancel telescoping is an open `sorry` (line 1445). Blueprint proof block has no `\leanok` ✓ (honest). Chapter proof sketch says "apply the three cancel atoms" but gives no hint about the formalization obstacle (see blueprint adequacy below).
- **Notes**: The sorry carries detailed internal comments (lines 1392–1444) documenting the `X.Modules` instance diamond. The blueprint has no corresponding obstacle description.

### `lem:base_change_mate_inner_eCancel_assemble` — no dedicated Lean declaration

- **Lean target exists**: N/A — blueprint explicitly annotates `% LEAN INTERNAL: no dedicated Lean declaration; content is the final telescoping inside base_change_mate_fstar_reindex_legs`. **Correct and honest.**
- **Proof follows sketch**: **no** (open, same sorry as `_legs`). No proof `\leanok` ✓.
- **Notes**: This is the primary open obligation. See Red Flags §1.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` — `lem:base_change_mate_fstar_reindex`

- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: partial — body is `exact base_change_mate_fstar_reindex_legs ...` (sorry-backed via `_legs`). No proof `\leanok` ✓.
- **Notes**: Blueprint `\uses` chain and prose correctly reflect this is a legs-instantiation wrapper.

### `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` — `lem:base_change_mate_inner_value_eq`

- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: partial — body is `exact base_change_mate_fstar_reindex ψ φ M` (sorry-backed). No proof `\leanok` ✓. Blueprint correctly describes Seam-A routing through `_legs`.
- **Notes**: This declaration is cited in `lem:base_change_mate_gstar_transpose`'s proof sketch as if established — see Red Flags §2.

### gstar helpers (`gstar_counit_transport`, `gstar_generator_close`)

Both sorry-free. Blueprint blocks have proof `\leanok`. ✓

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` — `lem:base_change_mate_gstar_transpose`

- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: **no** — blueprint proof sketch lists 4 steps (counit factorization → counit transport → inner value via `lem:base_change_mate_inner_value_eq` → generator close); the Lean proof closes steps 1–2 (`gstar_counit_transport`) but then hits a `sorry` at line 1817 covering both "inner value (inline reproof)" and "generator close." **Proof-sketch step 3 is wrong about the available route** — the Lean comment at line 1743 explicitly states `base_change_mate_fstar_reindex` CANNOT be cited (sorry-backed), requiring an inline reproof; that inline reproof also has a `sorry`. No proof `\leanok` ✓.
- **Notes**: The sorry at line 1817 encodes the same eCancel diamond content as line 1445, independently manifested. See Red Flags §2.

### Downstream cascade declarations

| Lean declaration | Direct body sorry? | Transitive sorry via | BP stmt `\leanok` | BP proof `\leanok` | Consistent? |
|---|---|---|---|---|---|
| `base_change_mate_section_identity` | no | `gstar_transpose` | ✓ | absent | ✓ |
| `base_change_mate_generator_trace` | no | via section_identity | ✓ | absent | ✓ |
| `pushforward_base_change_mate_cancelBaseChange` | no | via generator_trace | ✓ | absent | ✓ |
| `affineBaseChange_pushforward_iso` | **yes** (line 1995) | own sorry | ✓ | absent | ✓ |
| `flatBaseChange_pushforward_isIso` | **yes** (line 2017) | own sorry | ✓ | absent | ✓ |
| `base_change_map_affine_local` | no | sorry-free | ✓ | (need check) | ✓ |

`lem:affine_base_change_pushforward` and `thm:flat_base_change_pushforward` have stmt `\leanok` and no proof `\leanok` — consistent with their open sorries. ✓

---

## Red flags

### §1 — Blueprint adequacy failure: `lem:base_change_mate_inner_eCancel_assemble` under-specified for Lean formalization

**Severity: must-fix-this-iter**

The chapter proof of `lem:base_change_mate_inner_eCancel_assemble` says:

> "Apply the three one-cancellation atoms in turn to the four-factor distribution, now read against the leg-parametrised codomain read … The lone survivor is the affine (Spec ιA)-unit, evaluated by Seam 1."

This is mathematically correct but fails as blueprint-level formalization guidance. The Lean file's sorry block (lines 1392–1444) documents:

1. `simp only [Functor.map_comp]` / `rw [Functor.map_comp]` make **no progress** on the four-factor goal — the `X.Modules` `CategoryStruct.comp` instance diamond blocks the keyed match.
2. `rw [hpfc]` / `simp only [hpfc]` report "no occurrence / no progress" for `gammaMap_pushforwardComp_hom_eq_id`.
3. `erw [gammaMap_pushforwardComp_hom_eq_id]` **times out**.
4. The viable route is term-mode congruence surgery — named in the comment but not elaborated.

The chapter gives zero description of the obstacle or the approach. A prover reading only the blueprint proof sketch for this lemma has no actionable path through the instance diamond. This is a blueprint-as-failure case: the chapter needed at least a `% NOTE:` annotation documenting the `X.Modules` instance diamond and indicating that term-mode congruence (not rewrite tactics) is required.

### §2 — Blueprint proof divergence: `lem:base_change_mate_gstar_transpose` step 3 cites sorry-backed dependency

**Severity: must-fix-this-iter**

The blueprint proof of `lem:base_change_mate_gstar_transpose` (step "Inner value (Seam A)") says: cite `lem:base_change_mate_inner_value_eq`. But `base_change_mate_inner_value_eq` is sorry-backed (via `fstar_reindex` → `fstar_reindex_legs`). The Lean code at line 1743 explicitly states:

> "NOTE the existing Seam-2 lemma `base_change_mate_fstar_reindex` asserts exactly this but is currently sorry-backed (its `…_legs` apparatus carries a dead `sorry`), so this content must be REPROVEN INLINE here, not cited — otherwise the result is not axiom-clean."

The blueprint says "cite X" but the Lean code says "can't cite X, must reprove inline." The inline reproof itself has a sorry (line 1817) because it hits the same eCancel diamond as `fstar_reindex_legs`. The result: there are **two independent direct sorries** (lines 1445 and 1817) encoding mathematically identical content, with no blueprint-level documentation that this is the case or why.

The blueprint proof sketch for `lem:base_change_mate_gstar_transpose` needs to be updated to reflect that step 3 cannot yet cite `lem:base_change_mate_inner_value_eq` and that the inline reproof is the current obligated path (itself sorry-blocked at the same diamond).

### §3 — Misleading "sorry-free" docstrings in Lean (Lean-side, blueprint consistent)

**Severity: major**

`base_change_mate_section_identity` (Lean docstring, line ~1837): "This theorem itself is **sorry-free**."
`pushforward_base_change_mate_cancelBaseChange` (Lean docstring, line ~1907): "This theorem itself is **sorry-free**."

Both declarations are transitively sorry-backed (via `gstar_transpose`). The docstrings are technically true in the narrow sense that the direct proof bodies contain no `sorry` keyword — but calling them "sorry-free" is misleading to anyone checking axiom-cleanliness. The `sync_leanok` correctly withholds proof `\leanok` from both, so the blueprint is consistent. Nevertheless, the Lean-side documentation is a reader trap.

Note: this is a documentation issue in the Lean file itself, not a blueprint issue. The blueprint is not making the incorrect claim.

### §4 — Private declarations with public-form `\lean{...}` references (minor)

**Severity: minor**

`gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, and `gammaMap_pushforwardCongr_hom` are all declared `private lemma` in the Lean file. In Lean 4, `private` declarations receive a mangled internal name (not the bare name). The blueprint references them via public-form `AlgebraicGeometry.gammaMap_pushforwardComp_*` names. These `\lean{...}` hints will fail to resolve in `leandag` (producing isolated nodes), and `lean_verify` / `sorry_analyzer` will not find them by the public name. Workaround: promote the three to non-private or add `\lean{}`-annotated public aliases.

### §5 — `lem:base_change_regroup_linearEquiv` phantom (minor, informational)

**Severity: minor**

`lem:base_change_regroup_linearEquiv` appears in the `\uses` list of `lem:base_change_mate_regroupEquiv` and is referenced as "the standalone geometry-free helper Lemma~\ref{lem:base_change_regroup_linearEquiv}." No `\lean{...}` block exists for it, and no Lean declaration named `base_change_regroup_linearEquiv` (or close variant) was found in `FlatBaseChange.lean`. The Lean proof of `base_change_mate_regroupEquiv` folds its content directly (no helper lemma). Either this is a cross-chapter informal lemma (in which case the `\uses` reference is forward-pointing to a non-existent Lean target) or a phantom. Not blocking; the chapter carries the right mathematical content in `lem:base_change_mate_regroupEquiv` itself.

---

## Unreferenced declarations (informational)

The following substantial Lean declarations in the file have no `\lean{...}` in the chapter. Most are internal plumbing:

- `base_change_mate_gstar_counit_transport` — sorry-free; chapter discusses its content inline in `lem:base_change_mate_gstar_transpose`'s proof sketch but assigns no dedicated block. Given its standalone status as a seam-C helper, a blueprint block would be informative.
- `base_change_mate_gstar_generator_close` — sorry-free; same situation.

These two are the only substantive sorry-free helpers lacking dedicated blueprint blocks. Both serve specific single-caller roles and are internally named; not blocking but worth adding as informational blueprint nodes if the chapter receives a revision pass.

All remaining unreferenced items are internal helpers (private implementations, localization plumbing, `Iso`-unwinding lemmas) with no blueprint obligation.

---

## Blueprint adequacy for this file

- **Coverage**: ~50/52 Lean declarations have a corresponding `\lean{...}` block (or are correctly noted as having no dedicated decl). 2 sorry-free substantive helpers (`gstar_counit_transport`, `gstar_generator_close`) lack dedicated blocks — acceptable but worth adding.
- **Proof-sketch depth**: **under-specified** for two blocks:
  - `lem:base_change_mate_inner_eCancel_assemble`: mathematically correct but Lean-formalization-opaque; the `X.Modules` instance diamond obstacle is entirely absent.
  - `lem:base_change_mate_gstar_transpose`: proof-sketch step 3 cites a sorry-backed dependency as if established; Lean code explicitly rejected that path.
- **Hint precision**: **loose** for the three `private` lemmas (public names in `\lean{...}`, private in Lean). Otherwise precise.
- **Generality**: matches need.
- **Recommended chapter-side actions**:
  1. Add a `% NOTE:` (or inline prose) to `lem:base_change_mate_inner_eCancel_assemble`'s proof block documenting the `X.Modules` `CategoryStruct.comp` instance diamond: `simp only [Functor.map_comp]` / `erw [gammaMap_pushforwardComp_*]` all fail; term-mode congruence surgery is the route. Name the pattern (composed-functor vs nested-obj domain mismatch after `rw [Functor.map_comp]` split).
  2. Update `lem:base_change_mate_gstar_transpose` proof sketch step 3 to say: "Seam-A inner value step currently cannot cite `lem:base_change_mate_inner_value_eq` (sorry-backed); it must be reproved inline — and that inline reproof is itself blocked by the same eCancel diamond as `lem:base_change_mate_fstar_reindex_legs`."
  3. Promote or alias the three `gammaMap_pushforwardComp_*` private lemmas to non-private so `\lean{...}` references resolve.
  4. Clarify `lem:base_change_regroup_linearEquiv`: add a `\lean{...}` block if a Lean declaration is forthcoming, or remove from `\uses` of `lem:base_change_mate_regroupEquiv` if it is to remain informal.
  5. Add dedicated blueprint blocks for `base_change_mate_gstar_counit_transport` and `base_change_mate_gstar_generator_close` (informational; not blocking).

---

## Severity summary

| # | Finding | Severity |
|---|---|---|
| 1 | `lem:base_change_mate_inner_eCancel_assemble` proof sketch completely silent on `X.Modules` instance diamond; blueprint cannot guide the formalization | **must-fix-this-iter** |
| 2 | `lem:base_change_mate_gstar_transpose` step 3 cites `inner_value_eq` (sorry-backed); Lean explicitly says can't cite it; two independent direct sorries (lines 1445, 1817) with same content undocumented | **must-fix-this-iter** |
| 3 | Lean docstrings for `section_identity` and `cancelBaseChange` claim "sorry-free" while both are transitively sorry-backed; blueprint is consistent, Lean side misleads | **major** |
| 4 | Three `private` lemmas referenced by public-form `\lean{...}`; `leandag` resolution broken | **minor** |
| 5 | `lem:base_change_regroup_linearEquiv` in `\uses` without `\lean{...}` or Lean declaration | **minor** |

**Overall verdict**: Lean–blueprint routing is consistent (Seam-A correctly realized through `_legs`; all `\lean{...}` declarations present and signature-matching), but the chapter carries 2 must-fix blueprint-adequacy failures — the eCancel instance-diamond obstacle is undescribed, and the `gstar_transpose` proof sketch incorrectly cites a sorry-backed dependency as if established — leaving both open sorries (lines 1445 and 1817) without actionable blueprint guidance.

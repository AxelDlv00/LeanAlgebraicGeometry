# Lean ↔ Blueprint Check Report

## Slug
cechbridge

## Iteration
020

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechBridge.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (`% archon:covers AlgebraicJacobian/Cohomology/CechBridge.lean`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechComplex_hom_identification}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes (line 262)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.PresheafOfModules) : homCechComplex 𝒰 F ≅ sectionCechComplex (coverOpen 𝒰) F`, matching the prose isomorphism `Hom(K(𝒰)_•, F) ≅ Č•(𝒰, F)`
- **Proof follows sketch**: yes — obtained as `(alternatingCofaceMapComplex Ab).mapIso (homCechSectionCosimplicialIso 𝒰 F)`, exactly the "assemble via `alternatingCofaceMapComplex.mapIso`" route in the blueprint
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` only — axiom-clean

### `\lean{AlgebraicGeometry.homCechCosimplicial}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes (line 132)
- **Signature matches**: yes — `(cechFreeSimplicial 𝒰).rightOp ⋙ preadditiveYoneda.obj F`, the contravariant transport of `cechFreeSimplicial` described in the blueprint
- **Proof follows sketch**: N/A (definition)

### `\lean{AlgebraicGeometry.homCechComplex}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes (line 145)
- **Signature matches**: yes — `(alternatingCofaceMapComplex Ab).obj (homCechCosimplicial 𝒰 F)`, matching the description as the alternating-coface-map complex of `homCechCosimplicial`
- **Proof follows sketch**: N/A (definition)

### `\lean{AlgebraicGeometry.homCechSectionIsoApp}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes (line 158)
- **Signature matches**: yes — per-degree iso `(homCechCosimplicial 𝒰 F).obj n ≅ (sectionCechCosimplicial (coverOpen 𝒰) F).obj n`, matching "per-degree hom-coproduct duality" from the blueprint sketch
- **Proof follows sketch**: yes — assembled from `opCoproductIsoProduct`, `piComparison`, and `freeYonedaHomAddEquiv`, the three-step decomposition described in the blueprint

### `\lean{AlgebraicGeometry.homCechSectionCosimplicialIso}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes (line 226)
- **Signature matches**: yes — `homCechCosimplicial 𝒰 F ≅ sectionCechCosimplicial (coverOpen 𝒰) F`, the cosimplicial natural iso from the blueprint
- **Proof follows sketch**: yes — `NatIso.ofComponents (homCechSectionIsoApp 𝒰 F)` with naturality driven by `freeYonedaHomAddEquiv_naturality`, matching the blueprint's "naturality of `freeYonedaHomAddEquiv`" route

### `\lean{AlgebraicGeometry.homCechSectionIsoApp_hom_π}` (private, `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes (line 177, `private lemma`)
- **Signature matches**: yes — characterises the `σ`-component as precomposition with `Sigma.ι σ` then `freeYonedaHomAddEquiv`, matching the blueprint's characterisation note
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.pi_mapIso_hom_eq}` (private, `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes (line 170, `private lemma`)
- **Signature matches**: yes — trivial `rfl` technical lemma unfolding `Pi.mapIso`, consistent with its description
- **Proof follows sketch**: N/A (auxiliary `rfl`)

### `\lean{AlgebraicGeometry.freeYonedaHomAddEquiv_naturality}` (private, `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes (line 200, `private lemma`)
- **Signature matches**: yes — naturality of `freeYonedaHomAddEquiv` in the open, the single square that drives cosimplicial naturality
- **Proof follows sketch**: yes

---

## Red flags

None.

- No `:= sorry` anywhere in the file (grep confirms 0 occurrences).
- No `axiom` declarations.
- No excuse-comments (`-- TODO`, `-- temporary`, `-- placeholder`, `-- wrong but works`).
- No suspect bodies (no `:= True`, no `Classical.choice _` on substantive claims).
- Axiom check for all four key public declarations returns only `propext / Classical.choice / Quot.sound` — the standard Lean kernel, no `sorry`-derived axioms.

---

## Unreferenced declarations (informational)

The following declarations exist in CechBridge.lean but have NO `\lean{...}` reference in any blueprint block:

### Private helpers — acceptable (no blueprint coverage needed)
- `homCechCosimplicial_δ` (line 285, `private lemma`) — technical `rfl` collapsing the δ of `homCechCosimplicial` to `(preadditiveYoneda.obj F).map (...).op`; pure driver for `homCechComplex_d_eq`
- `homCechComplex_d_eq` (line 296, `private lemma`) — degreewise differential identification driving `homCechComplexMapOpIso`; private helper, acceptable without blueprint entry

### Public substantive declarations — **not covered by any `\lean{...}` block** *(flagged)*

| Declaration | Line | Nature |
|---|---|---|
| `homCechComplexMapOpIso` | 337 | `noncomputable def` — cochain-complex iso `homCechComplex 𝒰 F ≅ (preadditiveYoneda.obj F).mapHomologicalComplex … (op (cechFreePresheafComplex 𝒰))` |
| `sectionCechComplexMapOpIso` | 359 | `noncomputable def` — composed iso identifying `sectionCechComplex (coverOpen 𝒰) F` with the mapped opposite of the free complex |
| `preadditiveYoneda_obj_preservesFiniteColimits_of_injective` | 397 | `instance` — `Hom(-, I)` preserves finite colimits for injective `I` |
| `quasiIso_map_preadditiveYoneda_of_injective` | 417 | `lemma` — `Hom(-, I)` carries quasi-isos to quasi-isos for injective `I` |

These four are public (non-private), axiom-clean, fully proved, and described in the Lean module header as key ingredients of the `injective_cech_acyclic` assembly. The blueprint has no block referencing them.

---

## Blueprint adequacy for this file

### Coverage
- **8 / 14** Lean declarations have a `\lean{...}` block in the chapter.
- **2 uncovered private helpers** (acceptable).
- **4 uncovered substantive public declarations** (flagged; see above).

### Proof-sketch depth
**Under-specified** for the iter-020 material.

The `lem:cech_complex_hom_identification` block and its proof sketch are thorough and adequate for the declarations they cover.

The `lem:injective_cech_acyclic` block (lines 1733–1827) describes the logical path (injective sheaf → injective presheaf → exact `Hom(-, I)` → apply to free-complex quasi-iso → Čech vanishing) at the correct level of abstraction, but it does **not** name or break down the sub-steps:

1. The blueprint does not describe that the assembly route goes via identifying `homCechComplex` with the mapped-opposite of the free complex (`homCechComplexMapOpIso`) and then composing with `cechComplex_hom_identification` to get `sectionCechComplexMapOpIso`. A prover following only the blueprint text would re-derive this routing from scratch.
2. The `\lean{...}` list of `lem:injective_cech_acyclic` references only `AlgebraicGeometry.injective_cech_acyclic` and `AlgebraicGeometry.injective_toPresheafOfModules`; neither `preadditiveYoneda_obj_preservesFiniteColimits_of_injective` nor `quasiIso_map_preadditiveYoneda_of_injective` appear anywhere in the blueprint.

Since `injective_cech_acyclic` is intentionally gated on Lane-1 `cechFreeComplex_quasiIso` this cycle, the under-specification does not block current work, but it does leave the prover without a blueprint-guided path once Lane-1 lands.

### Hint precision
**Adequate** for the covered blocks. The `\lean{...}` hints pin Lean names precisely and the signatures in the prose match the Lean signatures.

For `homCechComplexMapOpIso` / `sectionCechComplexMapOpIso` / the `InjectiveHomExact` helpers: **missing** (no hint at all).

### Generality
Matches need. The `InjectiveHomExact` declarations are stated for a general abelian category `C` rather than specifically for `X.PresheafOfModules`, which is exactly the right generality for reuse.

### Recommended chapter-side actions

A blueprint-writing pass should add the following to the chapter:

1. **Add `homCechComplexMapOpIso` and `sectionCechComplexMapOpIso` to `lem:cech_complex_hom_identification`** (or create a sub-lemma `lem:cech_complex_op_identification`). The bridge route is: the identity-component iso `HomologicalComplex.Hom.isoOfComponents (fun _ => Iso.refl _)` with `homCechComplex_d_eq` supplying the differential squares, then composing with `cechComplex_hom_identification`.

2. **Add a sub-lemma block** (e.g. `lem:hom_into_injective_exact`) for `preadditiveYoneda_obj_preservesFiniteColimits_of_injective` and `quasiIso_map_preadditiveYoneda_of_injective`. The prose exists (lines 366–380 of the Lean file give the argument), but no `\lean{...}` hint pins it.

3. **Add the assembly route to `lem:injective_cech_acyclic`'s `\lean{...}` list**: at minimum add `AlgebraicGeometry.homCechComplexMapOpIso`, `AlgebraicGeometry.sectionCechComplexMapOpIso`, `AlgebraicGeometry.preadditiveYoneda_obj_preservesFiniteColimits_of_injective`, `AlgebraicGeometry.quasiIso_map_preadditiveYoneda_of_injective` to the list so a prover can find these once Lane-1 lands.

---

## Severity summary

| Finding | Severity |
|---|---|
| 0 sorries | — (clean) |
| 0 axioms beyond standard kernel | — (clean) |
| `homCechComplexMapOpIso` not in any `\lean{...}` block | **major** |
| `sectionCechComplexMapOpIso` not in any `\lean{...}` block | **major** |
| `preadditiveYoneda_obj_preservesFiniteColimits_of_injective` not in any `\lean{...}` block | **major** |
| `quasiIso_map_preadditiveYoneda_of_injective` not in any `\lean{...}` block | **major** |
| Blueprint under-specified for `injective_cech_acyclic` assembly path | **major** (non-blocking this iter; gated on Lane-1) |

No **must-fix-this-iter** findings. All public Lean declarations that exist are axiom-clean, correctly signed, and fully proved. The four major findings are blueprint-side gaps that a blueprint-writing pass should address before Lane-1 `cechFreeComplex_quasiIso` lands.

**Overall verdict**: CechBridge.lean is axiom-clean with 0 sorries and all `\lean{}`-referenced declarations matching the blueprint faithfully; the major gap is that 4 substantive public declarations added in iter-019/020 (`homCechComplexMapOpIso`, `sectionCechComplexMapOpIso`, `preadditiveYoneda_obj_preservesFiniteColimits_of_injective`, `quasiIso_map_preadditiveYoneda_of_injective`) have no corresponding `\lean{...}` blocks in the blueprint, leaving the `injective_cech_acyclic` assembly path undocumented.

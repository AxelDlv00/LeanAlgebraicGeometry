# Blueprint-Writer Directive — Route B for 01I8 (chapter `Cohomology_CechHigherDirectImage.tex`)

## Scope
Edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. You author informal
mathematical prose, `\lean{}` hints, and `\uses{}` edges. Do NOT add `\leanok` (the deterministic
sync owns it). You MAY mark `\mathlibok` ONLY on genuine Mathlib dependency anchors named below.

## Strategy context (the slice that matters)
The project's load-bearing affine lemma is **01I8**: for a quasi-coherent sheaf of modules `F` on an
affine scheme `Spec R`, the counit `F.fromTildeΓ : tilde(Γ(X,F)) ⟶ F` is an isomorphism (equivalently
`F ≅ tilde M` for some `R`-module `M`). This iter PIVOTS the route from the old "Route P" (global
generation: P1a affine-restriction → P2 global-generation → P3 kernel-quasicoherent →
`tildePreservesFiniteLimits`) to **Route B (section-localization)**, which the mathlib-analogist
established as the shortest Mathlib-aligned path (full rationale in `analogies/o1i8-route.md` — READ IT
FIRST). Route B drops the tilde-base-change wall, `tildePreservesFiniteLimits`, P2, and P3 from the
critical path.

### Route B, mathematically (author this as the new 01I8 critical chain)
Mathlib's counit `Scheme.Modules.fromTildeΓ` (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean`, def at
line 195) is defined so that on each standard basic open `D(f)` (`f : R`) its section component is
**literally** `IsLocalizedModule.lift (.powers f) (tilde.toOpen … D(f)) (restriction Γ(X,F) → Γ(D(f),F))`
(Tilde.lean line 200–202). Consequently:

- **(P1) The keystone.** For quasi-coherent `F` and `f : R`, the section-restriction map
  `ρ_f : Γ(Spec R, F) → Γ(D(f), F)` exhibits `Γ(D(f),F)` as the localization of `Γ(Spec R,F)` away from
  `f`: `IsLocalizedModule (Submonoid.powers f) ρ_f`. Proof outline: cover `Spec R` by finitely many basic
  opens `D(gᵢ)` (quasi-compactness of `Spec R`) on each of which the quasi-coherent `F` is presented as a
  cokernel of free modules (the local `QuasicoherentData` / `Presentation` data carried by
  `IsQuasicoherent`). For the free pieces, section-localization is the structure-sheaf localization
  (`tilde.toOpen … D(f)` is `IsLocalizedModule`, Tilde.lean line 115); it transfers through the cokernel
  by right-exactness and through the cover by the project's already-built **P1b**
  `isLocalizedModule_of_span_cover` (the pure-algebra span-cover descent of `IsLocalizedModule`) together
  with the standard-cover Čech exactness already proven in `CechAcyclic.lean`
  (`sectionCech_affine_vanishing` / `sectionCech_homology_exact`). This is exactly Stacks 01HV
  (Γ(D(f),~M)=M_f) lifted from `tilde M` to a general quasi-coherent `F`.
- **(P2+P3) Assembly.** Since `Γ(X,F) → Γ(D(f),F)` is `IsLocalizedModule (.powers f)` and the
  `D(f)`-component of `F.fromTildeΓ` is the corresponding `IsLocalizedModule.lift`, that component is an
  isomorphism for every `f`. A morphism of sheaves of modules that is an isomorphism on the basis of
  basic opens `{D(f)}` is an isomorphism (the forgetful `SheafOfModules.forget` / `SheafOfModules.toSheaf`
  reflects isomorphisms — `Mathlib/Algebra/Category/ModuleCat/Sheaf.lean:80,113`,
  `.../Presheaf/Sheafification.lean:41` — and a sheaf morphism iso on a basis / on all stalks is iso,
  `Mathlib/Topology/Sheaves/Stalks.lean`). Hence `IsIso F.fromTildeΓ`, the 01I8 instance, which upgrades
  the project's conditional `qcoh_iso_tilde_sections` (in `QcohTildeSections.lean`, currently under
  `[IsIso F.fromTildeΓ]`) to the unconditional `[IsQuasicoherent F]` form.

You must verify the exact Mathlib handle names via the LSP and write the proof sketch at textbook rigor,
with the Stacks 01I8 / 01HV verbatim source quotes (read `references/stacks-schemes.tex` for 01HV =
`lemma-spec-sheaves`; locate the qcoh-affine statement — likely Stacks tag 01I8 / a `quasi-coherent`
chapter lemma — read the actual `references/*.tex` and quote VERBATIM with `% SOURCE:` /
`% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` per the citation discipline; if the precise tag's source
file is not under `references/`, dispatch a `reference-retriever` child — your `--write-domain` includes
`references/**` for exactly this).

### Suggested new blocks (align labels to chapter conventions; reuse `rem:o1i8_decomposition` framing)
- `lem:qcoh_section_isLocalizedModule` — P1 keystone above. `\uses{lem:isLocalizedModule_of_span_cover,`
  `<the qcoh local-presentation fact>, <standard-cover Čech exactness label e.g. lem:sectionCech_affine_vanishing>}`.
  `\lean{}` left for the prover to fill once the decl exists (write the block WITHOUT a `\lean{}` pin to a
  non-existent name, or pin the intended name and note it is to-build — match how the chapter handles
  to-build targets elsewhere).
- `lem:qcoh_isIso_fromTildeΓ` — the assembly: `[IsQuasicoherent F] → IsIso F.fromTildeΓ`.
  `\uses{lem:qcoh_section_isLocalizedModule}` + a `\mathlibok` anchor for `fromTildeΓ`'s
  `IsLocalizedModule.lift` component and for `SheafOfModules.toSheaf`/`forget` reflecting isos.
- Add a `\mathlibok` **Mathlib dependency anchor** block for: `Scheme.Modules.fromTildeΓ`
  (`\lean{AlgebraicGeometry.Scheme.Modules.fromTildeΓ}`), `isIso_fromTildeΓ_iff`
  (`\lean{AlgebraicGeometry.isIso_fromTildeΓ_iff}`), and the basis/stalk iso-reflection lemma you settle
  on. State each in project notation and mark `\mathlibok` (these are genuine Mathlib re-exports).

### Demote the OFF-PATH (Route-A fallback) blocks — keep them, sever the 01I8 cone edges
The following blocks describe declarations that are now OFF the critical path (Route A fallback). Their
proven Lean decls stay as dormant axiom-clean assets — do NOT delete the blocks — but **remove their
`\uses{}` edges from the 01I8 target's cone** and add a one-line prose remark in each that it is a
Route-A fallback superseded by Route B (cite `analogies/o1i8-route.md`):
- `lem:tilde_preserves_kernels` (and its sub-step A/B prose, `stalkMapₗ` family) — `tildePreservesFiniteLimits`
  is no longer needed. (Do NOT spend effort fleshing out its sub-step (B); it is dropped.)
- `lem:tilde_restrict_basicOpen`, `lem:modules_restrict_basicOpen`, `lem:presentation_restrict_basicOpen`,
  `lem:isQuasicoherent_restrict_basicOpen` — the P1a base-change chain. (`lem:modules_restrict_basicOpen`'s
  two Lean decls are proven/axiom-clean; keep the block, mark it Route-A fallback.)

### Coverage-debt wire-up (must-fix from blueprint-reviewer iter036)
Author blueprint entries (statement + `\label` + `\lean{}` + accurate `\uses{}` + one-line informal proof)
for these 7 proved helpers so the DAG sees them (they may live as sub-lemma blocks under the dormant
fallback blocks, which is fine — the point is they stop being isolated `lean_aux` nodes):
- `AlgebraicGeometry.stalkMapₗ`, `…stalkMapₗ_eq`, `…stalkMapₗ_injective`, `…tilde_germ_algebraMap_smul`
  (under `lem:tilde_preserves_kernels`; `\uses{lem:tilde_preserves_kernels}` and among themselves
  `stalkMapₗ_injective` `\uses` `stalkMapₗ_eq` `\uses` `stalkMapₗ`).
- `AlgebraicGeometry.specBasicOpen`, `…specAwayToSpec`, `…specAwayToSpec_eq` (under
  `lem:modules_restrict_basicOpen`; `specAwayToSpec_eq` `\uses{specAwayToSpec block}`,
  `specAwayToSpec` `\uses{lem:modules_restrict_basicOpen}`).

### Header + stale-NOTE cleanup (must-fix / soon from blueprint-reviewer iter036)
- Add `% archon:covers AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` to the chapter's
  `% archon:covers` header list (the file is covered by this chapter).
- Prune the stale iter-034 MUST-FIX NOTE on `def:affine_cover_system` (≈ lines 3725–3736): it describes a
  `Cov` covering-condition bug that was FIXED in iter-035 (the Lean and prose are now aligned), so the
  NOTE is factually false. Remove it.

## Out of scope
- Do NOT touch other chapters. Do NOT add `\leanok`. Do NOT write Lean tactic code in the prose.
- Do NOT delete the dormant fallback blocks — only sever their 01I8 cone `\uses` edges and add the
  fallback remark.

## Citations
Every new statement/proof block deriving from Stacks must carry `% SOURCE:` + `% SOURCE QUOTE:` (verbatim,
original language) read from the actual `references/*.tex` file, plus a visible `\textit{Source: …}` line.
If you need a Stacks source file not present under `references/`, spawn a `reference-retriever` child.

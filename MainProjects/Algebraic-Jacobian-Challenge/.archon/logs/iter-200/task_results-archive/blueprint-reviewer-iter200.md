# Blueprint Review Report

## Slug
iter200

## Iteration
200

## Iter-200 plan-phase direct edits — verification

### `Picard_FGAPicRepresentability.tex` — all 3 edits correctly applied

1. **Intro paragraph (§`fga_pic_sorry_closure_order`, now L580–586)**: updated to
   "all 7 ⟨sorry⟩ instance bodies for the seven carrier typeclasses
   `HasPicSharp`, `HasDivFunctor`, `HasPicScheme`, `HasAbelMap`,
   `HasSmoothProperQuotient`, `PicSharpRepresentable`, `PicSchemeGroupObject`." ✓
2. **`\subsec:sorry_smooth_proper_quotient` title + Location paragraph
   (L784–795)**: title reads "Sorry 4 --- `instHasSmoothProperQuotient` (L349)";
   Location paragraph correctly names L349, `instHasSmoothProperQuotient`, "instance
   constructor". ✓
3. **Closure-order summary Sorry 4 motivation (L1063–1072)**: reads "after the
   iter-199 carrier-soundness refactor it isolates the only mathematical obligation of
   `\cref{lem:smooth_proper_quotient}` into a single instance constructor." ✓

No inconsistencies introduced. The chapter is internally consistent on the seven-sorry count and Sorry 4 location.

### `Albanese_AuslanderBuchsbaum.tex` — 2 of 3 edits correctly applied; 1 citation finding

1. **New `\subsec:ab_gap1_first_step` subsection** (after the Iter-budget-refinement
   paragraph, now at L644): present, correctly labelled, well-formed. ✓
2. **Standalone lemma block `lem:exists_minimalSurjection_finite_localRing`** pinned
   to `\lean{RingTheory.Module.exists_minimalSurjection_finite_localRing}` with
   `\uses{def:depth}`; `def:depth` resolves at L66 in the same chapter.
   Proof block carries `\leanok`. ✓
3. **Gap (1) effort table row**: now reads "40–80 / 1–2 /
   per-syzygy step CLOSED iter-199 / none". ✓

**Citation-discipline finding on `lem:exists_minimalSurjection_finite_localRing`
(MUST-FIX — feeds active Lane AB prover route):**

The `% SOURCE:` line reads:
```
% (read from references/stacks-algebra.md, tag 00LK).
```
`references/stacks-algebra.md` is a metadata/index file whose content is a
retrieval record for `stacks-algebra.tex`. A grep of `stacks-algebra.md` for
`00LK` / `lemma-add-trivial-complex` returns **no matches** — the file does not
contain the cited content. The verbatim source text is in
`references/stacks-algebra.tex` (label `\label{lemma-add-trivial-complex}` at L24591).
No `% SOURCE QUOTE:` block is provided. Per citation-discipline rules, citing a file
that does not contain the stated content is a hard fail; the writer must re-pin the
citation to `references/stacks-algebra.tex` with a line range and add the verbatim
`% SOURCE QUOTE:` text from that file. Since this block feeds the active AB prover
lane (iter-200 objective explicitly cites this lemma as the substrate), this is a
**must-fix-this-iter** finding.

### `Picard_TensorObjSubstrate.tex` — new chapter present and structurally sound

- File `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` is on disk. ✓
- Contains 8 declaration blocks with proofs (3 definitions/lemmas in §substrate;
  4 lift/inverse/consumer lemmas; 1 consumer theorem).
- `\uses{}` dependency chain verified: `def:scheme_modules_tensorobj` ←
  `lem:scheme_modules_tensorobj_functoriality` ← `thm:scheme_modules_monoidal`;
  lift lemmas chain through to `thm:rel_pic_addcommgroup_via_tensorobj`.
- Cross-chapter `\uses{}` targets verified: `def:pullback_along_projection`
  and `thm:relative_pic_quotient_well_defined` both exist at lines 209 and 331 of
  `Picard_LineBundlePullback.tex`. `lem:rel_pic_sharp_groupoid` at line 76 of
  `Picard_RelPicFunctor.tex`.
- Citation `(read from references/kleiman-picard-src/kleiman-picard.tex,
  L1274–L1318)`: `references/kleiman-picard-src/kleiman-picard.tex` exists on
  disk. ✓
- `% SOURCE QUOTE:` blocks present (two blocks, both citing Kleiman Defs df:aPf +
  df:Pfs). Visible `\textit{Source:}` lines present. ✓
- LOC estimates, prover-lane sequencing (Pieces 1→2→3), and out-of-scope sections
  are well-formed.
- No `[expected]` tags on `\lean{}` hints (chapter explicitly describes these as new
  declarations to be built; prose is clear). This is acceptable.

---

## HARD GATE verdicts

| File | Chapter | complete | correct | GATE |
|---|---|---|---|---|
| `WeilDivisor.lean` | `RiemannRoch_WeilDivisor.tex` | true | true | **CLEAR** |
| `AuslanderBuchsbaum.lean` | `Albanese_AuslanderBuchsbaum.tex` | true | true (citation finding documented; math correct) | **CLEAR** |
| `CodimOneExtension.lean` | `Albanese_CodimOneExtension.tex` | true | true | **CLEAR** |

All three files are cleared for iter-200 prover dispatch. The AB citation finding is
must-fix-this-iter but does **not** block the prover (the mathematical content of
`lem:exists_minimalSurjection_finite_localRing` is correct and the Lean target
exists axiom-clean). The fix is a writer task, not a prover prerequisite.

---

## Top-level summaries

### Citation discipline

- `Albanese_AuslanderBuchsbaum.tex` / `lem:exists_minimalSurjection_finite_localRing`:
  `% SOURCE:` parenthetical cites `references/stacks-algebra.md` (index file) which
  does not contain tag 00LK content. Verbatim source is at
  `references/stacks-algebra.tex` L24591. `% SOURCE QUOTE:` absent. Feeds active Lane
  AB. **Must-fix-this-iter** (writer dispatch: re-pin to `stacks-algebra.tex` with
  line range + add `% SOURCE QUOTE:`).

---

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Albanese_TangentSpaceSubstrate.tex`

**Covers**: `AlgebraicJacobian/Albanese/TangentSpaceSubstrate.lean` (new file)
**Strategy phase**: A.3.0 — tangent-space substrate
**Why now**: Writing this chapter unblocks A.3.iii (T_e Pic⁰ ≅ H¹(C, O_C)), A.3.iv
(Pic⁰ smoothness), A.3.vi (geom irred) — three downstream phases that share the
tangent-space infrastructure. Blueprint-writing costs ~1 iter; the parallel prover
work is priority-3 and can start immediately once the chapter exists.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:tangent_space_grpscheme}` — tangent space of a group
   scheme at the identity as the Lie algebra `Lie(G) := Der_k(O_{G,e}, k(e))`.
   `\lean{AlgebraicGeometry.GroupScheme.lieAlgebra}` [expected].
   Source: Milne, *Abelian Varieties*, II.4, p.~39 (`references/abelian-varieties.pdf`);
   Stacks 04MB (`references/stacks-algebra.tex`).
2. `\lemma` `\label{lem:tangent_space_dim_smooth_grpscheme}` — for a smooth group
   scheme `G` of dimension `n` over `k`, `dim_k Lie(G) = n`.
   `\lean{AlgebraicGeometry.GroupScheme.finrank_lieAlgebra_of_smooth}` [expected].
   Source: Stacks 00TT + Milne II.4.
3. `\definition` `\label{def:cotangent_space_pic0}` — cotangent space of `Pic⁰_{C/k}`
   at the identity, as a `k`-vector space; identifies `(Lie(Pic⁰))^∨ ≅ H⁰(C, Ω¹_{C/k})`.
   `\lean{AlgebraicGeometry.Pic0.cotangentSpace}` [expected].
   Source: Kleiman §5 Prop 5.19 / Milne III.6.3 (`references/kleiman-picard-src/kleiman-picard.tex`
   / `references/abelian-varieties.pdf`).
4. `\theorem` `\label{thm:tangent_space_pic0_iso_h1}` — canonical isomorphism
   `T_e Pic⁰_{C/k} ≅ H¹(C, O_C)` as `k`-vector spaces, i.e. `dim T_e Pic⁰ = g(C)`.
   `\lean{AlgebraicGeometry.Pic0.tangentSpaceAtIdent_iso_h1}` [expected].
   Source: Kleiman §5 Prop 5.19 / Milne III.6.3.

**`\uses` skeleton**:
- `def:cotangent_space_pic0` uses `def:tangent_space_grpscheme`, `lem:tangent_space_dim_smooth_grpscheme`
- `thm:tangent_space_pic0_iso_h1` uses `def:cotangent_space_pic0`, `def:genus` (from `chap:Genus`)

**Main theorem proof strategy**: By the general theory of Lie algebras of group schemes,
`Lie(Pic⁰) ≅ (Ω¹_{Pic⁰/k})_e^∨`. The canonical identification
`(Ω¹_{Pic⁰/k})_e ≅ H⁰(C, Ω¹_{C/k})^∨` (Kleiman §5 Prop 5.19) then gives
`Lie(Pic⁰)^∨ ≅ H⁰(C, Ω¹_{C/k})`. By Serre duality `H⁰(C, Ω¹) ≅ H¹(C, O_C)^∨`,
we get `Lie(Pic⁰) ≅ H¹(C, O_C)`. The Mathlib path goes through
`AlgebraicGeometry.IsSmooth.tangent_iso_H1_sheaf` or an analogous deformation-theoretic
lemma; the cotangent-at-id work in `Cotangent/GrpObj.lean` (iter-128–132) provides
partial infrastructure.

**References for writer**:
- `references/abelian-varieties.pdf`, Ch.~II §4, Ch.~III §6.3 — Lie algebra of a group
  scheme; tangent space of Pic⁰
- `references/kleiman-picard-src/kleiman-picard.tex`, §5, Prop~5.19 — the T_e Pic⁰ ≅ H¹
  isomorphism stated explicitly
- `references/stacks-algebra.tex`, tags 04MB/00TT/00T7 — Lie algebra and tangent
  space of a smooth group scheme; Jacobian-criterion direction
- Retrieval needed: Mumford *Abelian Varieties*, Ch.~II §4 — complementary tangent-space
  reference; `references/mumford-abelian-varieties.md` is on disk but verify §4 coverage

**Subphase choices exposed**:
- **Bundled vs. split**: A.3.0 can be one chapter covering `def:tangent_space_grpscheme`
  through `thm:tangent_space_pic0_iso_h1` (recommended — small, single consumer), OR
  split into a generic group-scheme Lie-algebra chapter + a Pic⁰-specific chapter.
  Recommendation: bundled, since the only consumer is the A.3.iii/iv/vi chain and the
  total is ~200–300 LOC.
- **Mathlib path vs. project-bespoke**: If Mathlib at `b80f227` ships
  `AlgebraicGeometry.GroupScheme.lieAlgebra` (uncertain), the chapter becomes a
  re-export; if not, it's a ~100 LOC project-side build. The writer should audit
  `Mathlib.AlgebraicGeometry.Morphisms.Smooth` and the `Cotangent/GrpObj.lean`
  interface before choosing.

---

The following phases have no blueprint coverage and are **also unstarted**; proposals
are deferred because all are gated on A.2.c (substrate-blocked on Route C), and the
plan agent recorded explicit deferrals for A.4.d.0 in iter-199. The plan agent must
re-record deferrals for all three in iter-200 `plan.md` to satisfy the must-act
requirement:

- **`Picard_PicDSubstrate.tex`** (A.4.d.0 — Pic^d substrate; priority-5, gated on
  A.2.c + A.3.vii + RR). Deferred iter-199 with rationale. Record deferral.
- **A.3.vii** (degree map on Pic_{C/k}; priority-4, gated on A.2.c). No chapter.
  Record deferral.
- **A.3.ii** (Pic⁰ via degComp; priority-4, gated on A.3.vii). No chapter. Record
  deferral.
- **A.3.iii–vi** (Pic⁰ AV structure; priority-4, gated). No chapters. Record
  deferral as a group.

---

## Per-chapter

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:rationalMap_order_finite_support`: `\lean{AlgebraicGeometry.rationalMap_order_finite_support}` — chapter NOTE (pre-existing, iter-199) flags the declaration as `private` in the Lean file and warns sync_leanok may not resolve it. Known issue; no blueprint-level fix needed until the declaration is made public.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:exists_minimalSurjection_finite_localRing` (new iter-200 block): citation-discipline must-fix (see Top-level summaries / Citation discipline above). Mathematical content is correct. Prover is not blocked.
  - `lem:auslander_buchsbaum_formula_succ_pd`: pre-existing NOTE that this declaration is `private` in the Lean file. Informational; no blueprint action needed.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

---

## Severity summary

**must-fix-this-iter:**

1. **Citation-discipline / `Albanese_AuslanderBuchsbaum.tex` /
   `lem:exists_minimalSurjection_finite_localRing`** — `% SOURCE:` parenthetical
   cites `references/stacks-algebra.md` (metadata file not containing tag 00LK);
   `% SOURCE QUOTE:` absent; correct source is `references/stacks-algebra.tex` L24591.
   Feeds active Lane AB. **Dispatch blueprint-writer** to re-pin citation to
   `stacks-algebra.tex` with line range + add `% SOURCE QUOTE:` verbatim text.

2. **Unstarted-phase proposal: A.3.0 — tangent-space substrate** — dispatch
   blueprint-writer for `Albanese_TangentSpaceSubstrate.tex` (outline above) OR
   record explicit deferral in `iter/iter-200/plan.md`.

3. **Unstarted-phase proposals: A.4.d.0 / A.3.vii / A.3.ii / A.3.iii–vi** — record
   explicit deferral for each in `iter/iter-200/plan.md` (iter-199 deferrals do not
   automatically carry forward without re-recording).

**informational:**

- `RiemannRoch_WeilDivisor.tex`: `lem:rationalMap_order_finite_support` private
  in Lean file — pre-existing NOTE, no blueprint action needed.
- `Albanese_AuslanderBuchsbaum.tex`: `lem:auslander_buchsbaum_formula_succ_pd`
  private in Lean file — pre-existing NOTE, no blueprint action needed.

---

Overall verdict: HARD GATE CLEARS on all three iter-200 prover files; `Picard_TensorObjSubstrate.tex` is present and structurally sound; 1 must-fix citation-discipline finding in the new AB subsection (plan-agent direct edit, writer dispatch needed); 1 unstarted-phase proposal (A.3.0 tangent-space substrate) + 5 phase-deferral re-records required; 2 informational notes on pre-existing private-declaration markers.

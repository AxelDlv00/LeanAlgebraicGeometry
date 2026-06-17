# Blueprint-writer directive — slug `csi067`

## Chapter to edit (ONLY this file)

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter; it
`% archon:covers` `CechSectionIdentification.lean` among others).

## Strategy context (the slice that matters)

`CechSectionIdentification.lean` is Sub-brick A of the P5a-resolution `cechAugmented_exact`. Its two
top-level lemmas are already blueprinted and rated adequate:
- `lem:cechSection_complex_iso` (~line 8629) — evaluated augmented Čech complex ≅ concrete augmented
  section Čech complex `D'_aug`.
- `lem:cechSection_contractible` (~line 8704) — `D'_aug` is contractible when `V` lies in a cover member.

In iter-066 the prover built the augmentation-peeling assembly of `cechSection_complex_iso` and reduced
its body to two typed residuals: `coreIso` (the NON-augmented degreewise iso + differential match) and
`hcompat` (the degree-0 augmentation-compat square). To build that assembly it introduced three
sorry-free helper lemmas that currently have NO blueprint entry (coverage debt). Your job is to wire
them into the blueprint and sharpen two thin proof-sketch spots. This is additive cleanup — do NOT
change the statements of `cechSection_complex_iso` / `cechSection_contractible` or their `% NOTE:`
re-sign comments.

## Required additions

### 1. Three new helper-lemma blueprint blocks (coverage debt — MUST add)

Add three `\begin{lemma}…\end{lemma}` (+ `\begin{proof}…\end{proof}`) blocks, placed just BEFORE
`lem:cechSection_complex_iso` (they are the infrastructure that lemma's proof cites). Each needs a
`\label`, a `\lean{}` pin to the exact Lean name, an accurate `\uses{}`, and a one-to-three-sentence
informal proof. These are Archon-original helper lemmas (no external source — omit the SOURCE lines).

(a) **`mapHC_augment_iso`** — `\lean{AlgebraicGeometry.mapHC_augment_iso}`, label
`lem:mapHC_augment_iso`. Statement: for an additive functor `Φ` between abelian categories and a
cochain complex `C` with an augmentation object `Y` and augmentation map `f : Y → C₀` satisfying
`f ≫ C.d 0 1 = 0`, applying `Φ` degreewise commutes with `CochainComplex.augment`: there is an
isomorphism `(Φ.mapHomologicalComplex _).obj (C.augment f w) ≅ (Φ.obj-augmented complex)` whose every
component is the identity. Informal proof: the underlying graded objects of the two augmented complexes
agree on the nose (degree 0 = `Φ Y`, degree `n+1` = `Φ Cₙ`); build the iso via
`HomologicalComplex.Hom.isoOfComponents` with all components `Iso.refl`, the differential squares
closing by `simp [CochainComplex.augment]` in both the degree-0 and degree-`(n+1)` cases. `\uses{}`:
the augmentation definitions it sits over (e.g. `def:cech_augmented_complex` if relevant) — but keep it
minimal and accurate; this is a generic homological-algebra fact, so it may legitimately have an empty
or near-empty `\uses{}`.

(b) **`map_augment_cond`** — `\lean{AlgebraicGeometry.map_augment_cond}`, label
`lem:map_augment_cond`. Statement: the augmentation condition `f ≫ d⁰ = 0` is preserved by an additive
functor `Φ`: from `f ≫ C.d 0 1 = 0` deduce `Φ(f) ≫ (Φ.mapHC.obj C).d 0 1 = 0`. Informal proof:
reshape the middle object by definitional equality so `(Φ.mapHC.obj C).d 0 1 = Φ(C.d 0 1)`, then
`Φ(f) ≫ Φ(C.d 0 1) = Φ(f ≫ C.d 0 1) = Φ(0) = 0` by functoriality and `Φ.map_zero`. (minor — a short
technical block.)

(c) **`augmentCochainIso`** — `\lean{AlgebraicGeometry.augmentCochainIso}`, label
`lem:augmentCochainIso`. Statement: given a base-complex iso `φ : C ≅ C'`, an augmentation-object iso
`eY : Y ≅ Y'`, and a compatibility square `(isoApp φ 0).hom` intertwining the two augmentation maps
through `eY` (i.e. `f ≫ (isoApp φ 0).hom = eY.hom ≫ f'`), there is an iso of augmented complexes
`C.augment f w ≅ C'.augment f' w'`. Informal proof: `isoOfComponents` with the degree-0 component `eY`
and the degree-`(n+1)` component `isoApp φ n`; the degree-0 differential square is the supplied
compatibility square, and the degree-`(n+1)` squares reduce (via `CochainComplex.augment_d_succ_succ`)
to `φ.hom.comm`.

After adding these, add the three labels to the `\uses{}` of `lem:cechSection_complex_iso`'s proof
block (line ~8674) since its proof cites them directly.

### 2. Expand the thin `hcompat` proof-sketch (minor)

In the "Augmentation differential" paragraph of `lem:cechSection_complex_iso`'s proof (lines ~8693–8699),
add ONE sentence making explicit that the degree-0 compatibility square `hcompat` is **definitional up
to the section-functor adapter**: once the path `SheafOfModules.forget ⋙ restrictScalars (𝟙 ·)`
(= `Ψ`) followed by `PresheafOfModules.toPresheaf ⋙ evaluation (op V)` (= `GV`) is unfolded, the
augmentation map `GV(Ψ(cechAugmentation 𝒰 F))` IS the restriction product `ε`, so the square commutes
by `Iso.refl`/definitional reduction rather than a nontrivial diagram chase. This tells the next prover
`hcompat` is the degree-0 instance of `coreIso`'s differential match and closes definitionally through
the adapter.

### 3. Add a `coreIso` reduced-shape note (advisory)

In the same proof sketch, add one sentence noting that the augmentation-peeling step (via
`mapHC_augment_iso` ×2 and `augmentCochainIso`) reduces the goal to a **non-augmented** core iso
`coreIso : (GV ∘ Ψ)(cechComplexOnX 𝒰 F) ≅ sectionCechComplexV 𝒰 F V`, and that the differential-match
steps of this proof apply to that reduced goal (not the full augmented `D`). This prevents the next
prover from re-deriving the augmentation bookkeeping that the helpers already discharge.

## Out of scope

- Do NOT touch `lem:cechSection_contractible` (Stub 6) — its sketch is already rated adequate.
- Do NOT change any statement, `% NOTE:`, or `\lean{}` of the two main lemmas.
- Do NOT add or remove `\leanok` anywhere (sync_leanok owns it).
- No new external sources are needed; you should not need a reference-retriever.

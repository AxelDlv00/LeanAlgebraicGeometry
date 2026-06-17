## Target
`lem:gf_flat_locality_assembly` in `blueprint/src/chapters/Picard_FlatteningStratification.tex` (the G3 flat-locality assembly; effort_local ≈ 3957, frontier-ready). Its `\lean{}` is `AlgebraicGeometry.gf_flat_locality_assembly` (Lean decl does NOT exist yet — this is a build target).

## Granularity
One level: split the existing proof's named steps into \uses-linked sub-lemmas, EXCEPT the "Source reduction" step which is the deep piece — give it its own sub-lemma and, if Mathlib has no anchor for it, break it once more (fine).

## Proof structure (cut along these seams — already in the proof body)
- Step 1 free⇒flat per patch: `(M_j)_f` free over `A_f` ⟹ flat. Mathlib anchor `Module.Flat.of_free` [verified, Mathlib.RingTheory.Flat.Basic].
- Step 2 pointwise flatness of F over base on p⁻¹(V): stalk `F_x` = localization of `(M_j)_f`, flat over `O_{S,s}` (localization preserves flatness). Anchor: localization-of-flat (verify the exact name: candidates `Module.Flat.of_isLocalization` / `IsLocalization.flat` / `Localization.flatModule` — find the real one).
- Base reduction: flatness over `R = Γ(S,U)` detected at maximal ideals via `Module.flat_of_localized_maximal` [verified, Mathlib.RingTheory.Flat.Localization] — `N` flat over `R` iff `LocalizedModule P.primeCompl N` flat over `R` for all maximal `P`.
- **Source reduction (THE deep step):** flatness of `N_𝔭` over the LOCAL base `R_𝔭 = O_{S,x}` is detected at the SOURCE points `y ∈ W` (i.e. flatness over the base is local on the source affine `Spec B`). This is NOT `flat_of_localized_maximal` (that localizes over the SAME ring; here we localize `N` at primes of `B` but want flatness over the base `R_𝔭`). Determine whether Mathlib has "flatness over a base ring is local on the source / detected at source primes" (search `Module.Flat` localization/stalk API). If ABSENT, isolate it as a self-contained sub-lemma `lem:gf_flat_base_local_on_source` with a precise statement (B an R-algebra, N a B-module, N flat over R iff N_q flat over R for every maximal q of B) and a proof sketch via `flat_of_localized_maximal` over R composed with the source-localization being a localization of N — flag it clearly as the piece needing a project-side mathlib-build.
- Step 3 transitivity: `O_{S,x} → O_{S,p(y)}` a localization (flat), upgrade `F_y` flat over `O_{S,p(y)}` to flat over `O_{S,x}` via `Module.Flat.trans` [verified, Mathlib.RingTheory.Flat.Stability].

## Constraints
- Add `\mathlibok` Mathlib dependency anchors (statement in project notation + `\lean{}` naming the real Mathlib decl) ONLY for the four verified/located Mathlib lemmas above. Do NOT mark `\leanok` on anything.
- Each new sub-lemma: statement, `\label`, `\lean{}` (project name you choose, AlgebraicGeometry namespace), accurate `\uses{}`, and a textbook-level informal proof.
- Keep the top assembly `lem:gf_flat_locality_assembly` as the synthesis consuming the sub-lemmas; repoint its `\uses{}`.
- Cite the Nitsure §4 source already present in the chapter where relevant; you may spawn a reference-retriever if a flat-locality statement needs a Stacks tag.

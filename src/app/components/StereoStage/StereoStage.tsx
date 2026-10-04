import type { ReactNode } from "react";

import styles from "./StereoStage.module.css";

/**
 * Renders its children once per eye. On a normal screen only the left eye
 * shows. When the viewport is Full SBS shaped (3840×1080 on the glasses),
 * both eyes show side by side and each `<Layer>` shifts by its depth.
 */
export function StereoStage({ children }: { children: ReactNode }) {
	return (
		<main className={styles.stage}>
			<div className={styles.eye} data-eye="left">
				{children}
			</div>
			<div className={styles.eye} data-eye="right" inert>
				{children}
			</div>
		</main>
	);
}
